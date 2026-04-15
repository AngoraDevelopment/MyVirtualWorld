//
//  InputManager.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import AppKit
import MetalKit
import simd

final class InputManager: NSObject {

    // MARK: - Teclado
    private(set) var keysDown: Set<UInt16> = []

    // MARK: - Mouse
    private(set) var mousePosition: CGPoint = .zero
    private(set) var mouseDelta: SIMD2<Float> = .zero

    private(set) var didLeftClick: Bool = false
    private(set) var didRightClick: Bool = false

    private var trackingView: MTKView?

    // MARK: - Setup
    func attach(to view: MTKView) {
        trackingView = view
        view.window?.makeFirstResponder(view)
    }

    // MARK: - Frame reset
    func beginFrame() {
        mouseDelta = .zero
        didLeftClick = false
        didRightClick = false
    }

    // MARK: - Queries

    func isKeyDown(_ keyCode: UInt16) -> Bool {
        keysDown.contains(keyCode)
    }

    // MARK: - Mutations (internal API for InputMTKView)

    func setMousePosition(_ point: CGPoint) {
        mousePosition = point
    }

    func addMouseDelta(dx: Float, dy: Float) {
        mouseDelta += SIMD2<Float>(dx, dy)
    }

    func setLeftClick() {
        didLeftClick = true
    }

    func setRightClick() {
        didRightClick = true
    }

    func insertKeyDown(_ keyCode: UInt16) {
        keysDown.insert(keyCode)
    }

    func removeKeyDown(_ keyCode: UInt16) {
        keysDown.remove(keyCode)
    }
}

final class InputMTKView: MTKView {

    weak var inputManager: InputManager?

    override var acceptsFirstResponder: Bool { true }

    // MARK: - Keyboard

    override func keyDown(with event: NSEvent) {
        guard let inputManager else { return }
        inputManager.insertKeyDown(event.keyCode)
    }

    override func keyUp(with event: NSEvent) {
        guard let inputManager else { return }
        inputManager.removeKeyDown(event.keyCode)
    }

    // MARK: - Mouse Click

    override func mouseDown(with event: NSEvent) {
        guard let inputManager else { return }
        inputManager.setLeftClick()
        inputManager.setMousePosition(convert(event.locationInWindow, from: nil))
    }

    override func rightMouseDown(with event: NSEvent) {
        guard let inputManager else { return }
        inputManager.setRightClick()
        inputManager.setMousePosition(convert(event.locationInWindow, from: nil))
    }

    // MARK: - Mouse Move (para cámara después)

    override func mouseDragged(with event: NSEvent) {
        guard let inputManager else { return }
        inputManager.addMouseDelta(dx: Float(event.deltaX), dy: Float(event.deltaY))
    }

    override func rightMouseDragged(with event: NSEvent) {
        guard let inputManager else { return }
        inputManager.addMouseDelta(dx: Float(event.deltaX), dy: Float(event.deltaY))
    }

    override func mouseMoved(with event: NSEvent) {
        guard let inputManager else { return }
        inputManager.setMousePosition(convert(event.locationInWindow, from: nil))
    }
}
