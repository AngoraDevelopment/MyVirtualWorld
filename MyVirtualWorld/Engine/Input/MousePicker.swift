//
//  MousePicker.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import simd
import MetalKit

final class MousePicker {

    static func ray(from view: MTKView,
                    mousePosition: CGPoint,
                    camera: Camera) -> (origin: SIMD3<Float>, direction: SIMD3<Float>) {

        let size = view.bounds.size

        let x = (2.0 * Float(mousePosition.x) / Float(size.width)) - 1.0
        let invertY = false

        let y = invertY
            ? 1.0 - (2.0 * Float(mousePosition.y) / Float(size.height))
            : (2.0 * Float(mousePosition.y) / Float(size.height)) - 1.0

        let clipSpace = SIMD4<Float>(x, y, -1.0, 1.0)

        let projectionInv = simd_inverse(camera.projectionMatrix)
        let viewInv = simd_inverse(camera.viewMatrix)

        var eyeSpace = projectionInv * clipSpace
        eyeSpace = SIMD4<Float>(eyeSpace.x, eyeSpace.y, -1.0, 0.0)

        let worldSpace = viewInv * eyeSpace
        let direction = simd_normalize(SIMD3<Float>(worldSpace.x, worldSpace.y, worldSpace.z))

        return (camera.position, direction)
    }
}
