//
//  Zone.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import Foundation
import simd

final class Zone: Decodable {
    struct ZoneObject: Decodable {
        let id: String
        let kind: String
        let position: [Float]
        let rotation: [Float]?
        let scale: [Float]?
    }

    let id: String
    let gridX: Int
    let gridY: Int
    let objects: [ZoneObject]

    var worldOrigin: SIMD3<Float> {
        .zero
    }
}
