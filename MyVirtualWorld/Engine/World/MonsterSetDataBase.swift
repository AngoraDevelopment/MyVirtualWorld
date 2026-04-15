//
//  MonsterSetDataBase.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import Foundation

final class MonsterSetDatabase {
    private(set) var spotsByMap: [String: [MonsterSpawnSpot]] = [:]

    func load(from maps: [String: [MonsterSpawnSpot]]) {
        spotsByMap = maps
    }

    func spots(for mapName: String) -> [MonsterSpawnSpot] {
        spotsByMap[mapName.lowercased()] ?? []
    }
}
