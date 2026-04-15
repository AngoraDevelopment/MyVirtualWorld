//
//  MathUtils.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import simd

extension simd_float4x4 {
    static func identity() -> simd_float4x4 {
        matrix_identity_float4x4
    }

    static func translation(_ t: SIMD3<Float>) -> simd_float4x4 {
        simd_float4x4(
            SIMD4(1, 0, 0, 0),
            SIMD4(0, 1, 0, 0),
            SIMD4(0, 0, 1, 0),
            SIMD4(t.x, t.y, t.z, 1)
        )
    }

    static func scale(_ s: SIMD3<Float>) -> simd_float4x4 {
        simd_float4x4(
            SIMD4(s.x, 0, 0, 0),
            SIMD4(0, s.y, 0, 0),
            SIMD4(0, 0, s.z, 0),
            SIMD4(0, 0, 0, 1)
        )
    }

    static func rotation(radians: Float, axis: SIMD3<Float>) -> simd_float4x4 {
        let a = simd_normalize(axis)
        let x = a.x, y = a.y, z = a.z
        let c = cos(radians)
        let s = sin(radians)
        let mc = 1 - c

        return simd_float4x4(
            SIMD4(c + x*x*mc,     y*x*mc + z*s, z*x*mc - y*s, 0),
            SIMD4(x*y*mc - z*s,   c + y*y*mc,   z*y*mc + x*s, 0),
            SIMD4(x*z*mc + y*s,   y*z*mc - x*s, c + z*z*mc,   0),
            SIMD4(0, 0, 0, 1)
        )
    }

    static func perspective(fovY: Float, aspect: Float, near: Float, far: Float) -> simd_float4x4 {
        let y = 1 / tan(fovY * 0.5)
        let x = y / aspect
        let z = far / (near - far)

        return simd_float4x4(
            SIMD4(x, 0, 0, 0),
            SIMD4(0, y, 0, 0),
            SIMD4(0, 0, z, -1),
            SIMD4(0, 0, z * near, 0)
        )
    }

    static func lookAt(eye: SIMD3<Float>, center: SIMD3<Float>, up: SIMD3<Float>) -> simd_float4x4 {
        let z = simd_normalize(eye - center)
        let x = simd_normalize(simd_cross(up, z))
        let y = simd_cross(z, x)

        return simd_float4x4(
            SIMD4(x.x, y.x, z.x, 0),
            SIMD4(x.y, y.y, z.y, 0),
            SIMD4(x.z, y.z, z.z, 0),
            SIMD4(-simd_dot(x, eye), -simd_dot(y, eye), -simd_dot(z, eye), 1)
        )
    }
    
    static func intersectRayWithGround(origin: SIMD3<Float>,
                               direction: SIMD3<Float>,
                               groundY: Float = 0) -> SIMD3<Float>? {

        if abs(direction.y) < 0.0001 { return nil }

        let t = (groundY - origin.y) / direction.y
        if t < 0 { return nil }

        return origin + direction * t
    }
}
