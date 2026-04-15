//
//  MonsterDefinition.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import Foundation

struct MonsterDefinition: Decodable {
    let id: Int
    let key: String
    let name: String
    let level: Int
    let maxHP: Int
    let minDamage: Int
    let maxDamage: Int
    let defense: Int
    let attackRate: Int
    let defenseRate: Int
    let moveSpeed: Float
    let attackSpeed: Float
    let attackRange: Float
    let viewRange: Float
    let experience: Int
    let model: String
    let scale: Float
    let aggressive: Bool
    let element: String
    let notes: String?
}
