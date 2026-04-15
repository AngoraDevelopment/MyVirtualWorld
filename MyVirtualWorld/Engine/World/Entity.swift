//
//  Entity.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import simd

class Entity {
    let id: String
    var transform: Transform
    var meshName: String?

    init(id: String, transform: Transform = Transform(), meshName: String? = nil) {
        self.id = id
        self.transform = transform
        self.meshName = meshName
    }
}
