//
//  Camera.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import simd

final class Camera {
    var target: SIMD3<Float> = .zero
    var yaw: Float = 0
    var pitch: Float = -0.55
    var distance: Float = 10
    var heightOffset: Float = 3
    var aspectRatio: Float = 16.0 / 9.0

    var position: SIMD3<Float> {
        let x = cos(pitch) * sin(yaw) * distance
        let y = sin(-pitch) * distance + heightOffset
        let z = cos(pitch) * cos(yaw) * distance
        return target + SIMD3<Float>(x, y, z)
    }

    var viewMatrix: simd_float4x4 {
        .lookAt(eye: position, center: target, up: SIMD3<Float>(0, 1, 0))
    }

    var projectionMatrix: simd_float4x4 {
        .perspective(fovY: 60.0 * (.pi / 180.0), aspect: aspectRatio, near: 0.1, far: 500)
    }
}
