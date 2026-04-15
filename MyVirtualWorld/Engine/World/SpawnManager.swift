//
//  SpawnManager.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import Foundation
import simd

final class SpawnManager {
    private let monsterDatabase: MonsterDatabase
    private let monsterSetDatabase: MonsterSetDatabase

    init(monsterDatabase: MonsterDatabase, monsterSetDatabase: MonsterSetDatabase) {
        self.monsterDatabase = monsterDatabase
        self.monsterSetDatabase = monsterSetDatabase
    }

    func spawnMonsters(for mapName: String) -> [MonsterEntity] {
        let spots = monsterSetDatabase.spots(for: mapName)
        var result: [MonsterEntity] = []

        for spot in spots {
            guard let definition = monsterDatabase.monster(id: spot.monsterId) else {
                print("MonsterId inválido en spawn: \(spot.monsterId)")
                continue
            }

            for index in 0..<spot.count {
                let basePosition = resolveSpawnPosition(for: spot)
                var transform = Transform()
                transform.position = basePosition
                transform.scale = SIMD3<Float>(repeating: definition.scale)

                let entity = MonsterEntity(
                    id: "\(spot.spotId)_\(index)",
                    definition: definition,
                    sourceSpotId: spot.spotId,
                    transform: transform,
                    spawnCenter: basePosition,
                    spawnRadius: spot.radius ?? 0
                )
                result.append(entity)
            }
        }

        return result
    }

    private func resolveSpawnPosition(for spot: MonsterSpawnSpot) -> SIMD3<Float> {
        if let position = spot.position, position.count == 3 {
            return SIMD3<Float>(position[0], position[1], position[2])
        }

        if let min = spot.areaMin, let max = spot.areaMax, min.count == 3, max.count == 3 {
            let x = Float.random(in: min[0]...max[0])
            let y = Float.random(in: min[1]...max[1])
            let z = Float.random(in: min[2]...max[2])
            return SIMD3<Float>(x, y, z)
        }

        return .zero
    }
}
