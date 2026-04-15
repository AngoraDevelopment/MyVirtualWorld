//
//  MonsterFile.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/9/26.
//

struct MonsterFile: Decodable {
    let type: String
    let version: Int
    let monsters: [MonsterDefinition]
}
