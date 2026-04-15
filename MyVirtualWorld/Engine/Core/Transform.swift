//
//  Transform.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import simd

struct Transform {
    var position: SIMD3<Float> = .zero
    var rotation: SIMD3<Float> = .zero
    var scale: SIMD3<Float> = SIMD3(repeating: 1)

    var matrix: simd_float4x4 {
        let translation = simd_float4x4.translation(position)
        let rotationX = simd_float4x4.rotation(radians: rotation.x, axis: SIMD3(1, 0, 0))
        let rotationY = simd_float4x4.rotation(radians: rotation.y, axis: SIMD3(0, 1, 0))
        let rotationZ = simd_float4x4.rotation(radians: rotation.z, axis: SIMD3(0, 0, 1))
        let scaling = simd_float4x4.scale(scale)
        return translation * rotationY * rotationX * rotationZ * scaling
    }
}
