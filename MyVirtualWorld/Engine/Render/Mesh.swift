//
//  Mesh.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import Metal
import simd

final class Mesh {
    let vertexBuffer: MTLBuffer
    let vertexCount: Int

    init?(device: MTLDevice, vertices: [Vertex]) {
        guard let buffer = device.makeBuffer(bytes: vertices,
                                             length: MemoryLayout<Vertex>.stride * vertices.count,
                                             options: []) else {
            return nil
        }
        self.vertexBuffer = buffer
        self.vertexCount = vertices.count
    }

    static func makeCube(device: MTLDevice, size: Float = 1.0, color: SIMD4<Float> = SIMD4(0.7, 0.8, 1.0, 1.0)) -> Mesh? {
        let s = size * 0.5

        let p000 = SIMD3<Float>(-s, -s, -s)
        let p001 = SIMD3<Float>(-s, -s,  s)
        let p010 = SIMD3<Float>(-s,  s, -s)
        let p011 = SIMD3<Float>(-s,  s,  s)
        let p100 = SIMD3<Float>( s, -s, -s)
        let p101 = SIMD3<Float>( s, -s,  s)
        let p110 = SIMD3<Float>( s,  s, -s)
        let p111 = SIMD3<Float>( s,  s,  s)

        let vertices: [Vertex] = [
            // Front
            .init(position: p001, color: color), .init(position: p101, color: color), .init(position: p111, color: color),
            .init(position: p001, color: color), .init(position: p111, color: color), .init(position: p011, color: color),
            // Back
            .init(position: p100, color: color), .init(position: p000, color: color), .init(position: p010, color: color),
            .init(position: p100, color: color), .init(position: p010, color: color), .init(position: p110, color: color),
            // Left
            .init(position: p000, color: color), .init(position: p001, color: color), .init(position: p011, color: color),
            .init(position: p000, color: color), .init(position: p011, color: color), .init(position: p010, color: color),
            // Right
            .init(position: p101, color: color), .init(position: p100, color: color), .init(position: p110, color: color),
            .init(position: p101, color: color), .init(position: p110, color: color), .init(position: p111, color: color),
            // Top
            .init(position: p010, color: color), .init(position: p011, color: color), .init(position: p111, color: color),
            .init(position: p010, color: color), .init(position: p111, color: color), .init(position: p110, color: color),
            // Bottom
            .init(position: p000, color: color), .init(position: p100, color: color), .init(position: p101, color: color),
            .init(position: p000, color: color), .init(position: p101, color: color), .init(position: p001, color: color)
        ]

        return Mesh(device: device, vertices: vertices)
    }

    static func makeGround(device: MTLDevice, size: Float = 40.0, color: SIMD4<Float> = SIMD4(0.2, 0.55, 0.25, 1.0)) -> Mesh? {
        let s = size * 0.5
        let vertices: [Vertex] = [
            .init(position: SIMD3(-s, 0, -s), color: color),
            .init(position: SIMD3( s, 0, -s), color: color),
            .init(position: SIMD3( s, 0,  s), color: color),
            .init(position: SIMD3(-s, 0, -s), color: color),
            .init(position: SIMD3( s, 0,  s), color: color),
            .init(position: SIMD3(-s, 0,  s), color: color)
        ]
        return Mesh(device: device, vertices: vertices)
    }
}
