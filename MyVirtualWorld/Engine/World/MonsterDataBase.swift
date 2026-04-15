//
//  MonsterDataBase.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import Foundation

final class MonsterDatabase {
    private(set) var monstersById: [Int: MonsterDefinition] = [:]

    func load(from definitions: [MonsterDefinition]) {
        monstersById = Dictionary(uniqueKeysWithValues: definitions.map { ($0.id, $0) })
    }

    func monster(id: Int) -> MonsterDefinition? {
        monstersById[id]
    }

    func contains(id: Int) -> Bool {
        monstersById[id] != nil
    }
}
