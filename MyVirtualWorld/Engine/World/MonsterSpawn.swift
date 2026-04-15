//
//  MonsterSpawn.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import Foundation

struct MonsterSetBaseFile: Decodable {
    let maps: [String: [MonsterSpawnSpot]]
}

struct MonsterSpawnSpot: Decodable {
    let spotId: String
    let monsterId: Int
    let position: [Float]?
    let radius: Float?
    let count: Int
    let respawnTime: Float
    let spawnType: String
    let areaMin: [Float]?
    let areaMax: [Float]?
}
