//
//  GameView.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import SwiftUI
import MetalKit

struct GameView: NSViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeNSView(context: Context) -> MTKView {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal no está disponible en esta Mac.")
        }
        
        validateDataFolder()
        
        let view = InputMTKView(frame: .zero, device: device)
        view.inputManager = context.coordinator.inputManager
        view.colorPixelFormat = .bgra8Unorm
        view.depthStencilPixelFormat = .depth32Float
        view.clearColor = MTLClearColor(red: 0.08, green: 0.10, blue: 0.14, alpha: 1.0)
        view.preferredFramesPerSecond = 60
        view.enableSetNeedsDisplay = false
        view.isPaused = false

        let renderer = Renderer(mtkView: view)
        context.coordinator.renderer = renderer
        context.coordinator.inputManager.attach(to: view)
        renderer.input = context.coordinator.inputManager
        view.delegate = renderer
        
        return view
    }
    
    func updateNSView(_ nsView: MTKView, context: Context) {}

    final class Coordinator {
        let inputManager = InputManager()
        var renderer: Renderer?
    }
    
    func validateDataFolder() {
        let root = DataPathManager.shared.rootPath

        if !FileManager.default.fileExists(atPath: root.path) {
            print("No existe la carpeta de datos: \(root.path)")
        } else {
            print("Data path: \(root.path)")
        }
    }
}
