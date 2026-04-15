//
//  MapDefinition.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/9/26.
//

import Foundation
import simd

struct MapDefinition: Decodable {
    let type: String
    let version: Int
    let id: String
    let name: String
    let zoneSize: Float
    let zonesX: Int
    let zonesY: Int
    let origin: [Float]
    let defaultGroundY: Float

    var originVector: SIMD3<Float> {
        guard origin.count == 3 else { return .zero }
        return SIMD3<Float>(origin[0], origin[1], origin[2])
    }
}
