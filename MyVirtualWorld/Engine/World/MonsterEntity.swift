//
//  MonsterEntity.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import simd

final class MonsterEntity: Entity {
    let definition: MonsterDefinition
    let sourceSpotId: String

    var currentHP: Int
    var spawnCenter: SIMD3<Float>
    var spawnRadius: Float

    init(id: String,
         definition: MonsterDefinition,
         sourceSpotId: String,
         transform: Transform,
         spawnCenter: SIMD3<Float>,
         spawnRadius: Float) {
        self.definition = definition
        self.sourceSpotId = sourceSpotId
        self.currentHP = definition.maxHP
        self.spawnCenter = spawnCenter
        self.spawnRadius = spawnRadius
        super.init(id: id, transform: transform, meshName: definition.model)
    }
}
