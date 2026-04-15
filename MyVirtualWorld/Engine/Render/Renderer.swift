//
//  Renderer.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import Metal
import MetalKit
import simd

final class Renderer: NSObject, MTKViewDelegate {
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let pipelineState: MTLRenderPipelineState
    private let depthState: MTLDepthStencilState
    
    private let navigation = NavigationController()
    private var selectedMonster: MonsterEntity?

    var input: InputManager?

    private let camera = Camera()
    private let world = World()

    private var cubeMesh: Mesh
    private var groundMesh: Mesh

    init(mtkView: MTKView) {
        guard let device = mtkView.device,
              let commandQueue = device.makeCommandQueue() else {
            fatalError("No se pudo crear device o commandQueue")
        }

        self.device = device
        self.commandQueue = commandQueue

        let library = device.makeDefaultLibrary()!
        let vertexFunction = library.makeFunction(name: "vertex_main")!
        let fragmentFunction = library.makeFunction(name: "fragment_main")!

        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentFunction
        descriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
        descriptor.depthAttachmentPixelFormat = mtkView.depthStencilPixelFormat

        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0

        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0

        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        descriptor.vertexDescriptor = vertexDescriptor

        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: descriptor)
        } catch {
            fatalError("Error creando pipeline: \(error)")
        }

        let depthDescriptor = MTLDepthStencilDescriptor()
        depthDescriptor.isDepthWriteEnabled = true
        depthDescriptor.depthCompareFunction = .less
        guard let depthState = device.makeDepthStencilState(descriptor: depthDescriptor) else {
            fatalError("No se pudo crear depth state")
        }
        self.depthState = depthState

        guard let cube = Mesh.makeCube(device: device),
              let ground = Mesh.makeGround(device: device) else {
            fatalError("No se pudieron crear meshes base")
        }

        self.cubeMesh = cube
        self.groundMesh = ground

        super.init()

        world.player.transform.position = SIMD3(8, 0.5, 8)
        world.loadMap(named: "Lorencia")
        world.loadMonsterData()
        world.spawnMonsters(for: "lorencia")
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        guard size.height > 0 else { return }
        camera.aspectRatio = Float(size.width / size.height)
    }

    func draw(in view: MTKView) {
        updatePlayer(deltaTime: 1.0 / Float(max(view.preferredFramesPerSecond, 1)))
        
        world.updateStreamingZones()
        
        camera.target = world.player.transform.position

        guard let drawable = view.currentDrawable,
              let passDescriptor = view.currentRenderPassDescriptor,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: passDescriptor) else {
            return
        }
        
        handleMouseInput(view: view)
        navigation.update(player: world.player, deltaTime: 1.0 / 60.0)
        camera.target = world.player.transform.position
        
        encoder.setRenderPipelineState(pipelineState)
        encoder.setDepthStencilState(depthState)

        drawGround(with: encoder)

        for entity in world.entities {
            drawCube(entity.transform, with: encoder)
        }
        
        for monster in world.monsters {
            drawCube(monster.transform, with: encoder)
        }
        
        drawCube(world.player.transform, with: encoder, colorOffset: SIMD3<Float>(0.3, -0.1, -0.2))

        encoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
        
        input?.beginFrame()
    }

    private func updatePlayer(deltaTime: Float) {
        guard let input else { return }

        var direction = SIMD3<Float>(0, 0, 0)

        if input.isKeyDown(13) { direction.z -= 1 } // W
        if input.isKeyDown(1)  { direction.z += 1 } // S
        if input.isKeyDown(0)  { direction.x -= 1 } // A
        if input.isKeyDown(2)  { direction.x += 1 } // D

        if simd_length_squared(direction) > 0 {
            direction = simd_normalize(direction)
            world.player.transform.position += direction * world.player.moveSpeed * deltaTime
        }
    }

    private func drawGround(with encoder: MTLRenderCommandEncoder) {
        var transform = Transform()
        transform.position = SIMD3<Float>(0, 0, 0)
        submit(mesh: groundMesh, transform: transform, encoder: encoder)
    }

    private func drawCube(_ transform: Transform,
                          with encoder: MTLRenderCommandEncoder,
                          colorOffset: SIMD3<Float> = .zero) {
        submit(mesh: cubeMesh, transform: transform, encoder: encoder)
    }

    private func submit(mesh: Mesh, transform: Transform, encoder: MTLRenderCommandEncoder) {
        var uniforms = Uniforms(
            modelMatrix: transform.matrix,
            viewMatrix: camera.viewMatrix,
            projectionMatrix: camera.projectionMatrix
        )

        encoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        encoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 1)
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: mesh.vertexCount)
    }
    
    func pickMonster(rayOrigin: SIMD3<Float>,
                     rayDir: SIMD3<Float>) -> MonsterEntity? {

        var closest: MonsterEntity?
        var closestDist: Float = Float.greatestFiniteMagnitude

        for monster in world.monsters {
            let pos = monster.transform.position
            let radius: Float = 1.0 // simple

            let toSphere = pos - rayOrigin
            let projection = simd_dot(toSphere, rayDir)

            if projection < 0 { continue }

            let closestPoint = rayOrigin + rayDir * projection
            let dist = simd_length(pos - closestPoint)

            if dist < radius && projection < closestDist {
                closestDist = projection
                closest = monster
            }
        }

        return closest
    }
    
    private func handleMouseInput(view: MTKView) {
        guard let input, input.didLeftClick else { return }

        print("CLICK OK")

        let ray = MousePicker.ray(from: view,
                                  mousePosition: input.mousePosition,
                                  camera: camera)

        // 1. suelo
        if let hit = simd_float4x4.intersectRayWithGround(origin: ray.origin,
                                            direction: ray.direction) {

            print("MOVE TO:", hit)

            navigation.targetPosition = hit
            selectedMonster = nil
            return
        }

        print("NO HIT")
    }
}
