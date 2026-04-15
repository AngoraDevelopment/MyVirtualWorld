//
//  World.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import Foundation
import simd

final class World {
    var player = Player(id: "player")

    var entities: [Entity] = []
    var monsters: [MonsterEntity] = []

    let monsterDatabase = MonsterDatabase()
    let monsterSetDatabase = MonsterSetDatabase()
    let zoneManager = ZoneManager()

    private(set) var currentMapName: String?

    func loadMap(named mapFolder: String) {
        guard zoneManager.loadMap(named: mapFolder) else {
            print("No se pudo cargar el mapa \(mapFolder)")
            return
        }

        currentMapName = mapFolder
        entities.removeAll()
        monsters.removeAll()

        _ = zoneManager.updateZones(around: player.transform.position, radius: 1)
        rebuildEntitiesFromActiveZones()
    }

    func updateStreamingZones() {
        let changed = zoneManager.updateZones(around: player.transform.position, radius: 1)

        if changed {
            rebuildEntitiesFromActiveZones()
            print("Cambio de zona del player: \(zoneManager.currentPlayerZone?.x ?? -1), \(zoneManager.currentPlayerZone?.y ?? -1)")
        }
    }

    func rebuildEntitiesFromActiveZones() {
        entities.removeAll()

        let zones = zoneManager.activeZones()

        for zone in zones {
            let zoneOffset = zoneManager.worldPositionForZone(gridX: zone.gridX, gridY: zone.gridY)

            for object in zone.objects {
                var transform = Transform()

                if object.position.count == 3 {
                    transform.position = SIMD3(
                        object.position[0] + zoneOffset.x,
                        object.position[1] + zoneOffset.y,
                        object.position[2] + zoneOffset.z
                    )
                }

                if let rotation = object.rotation, rotation.count == 3 {
                    transform.rotation = SIMD3(rotation[0], rotation[1], rotation[2])
                }

                if let scale = object.scale, scale.count == 3 {
                    transform.scale = SIMD3(scale[0], scale[1], scale[2])
                }

                let entity = Entity(id: object.id, transform: transform, meshName: object.kind)
                entities.append(entity)
            }
        }
    }

    func loadMonsterData() {
        if let monsterFile = MonsterLoader.loadMonsterFile() {
            monsterDatabase.load(from: monsterFile.monsters)
        }

        if let setBaseFile = MonsterLoader.loadMonsterSetBaseFile() {
            monsterSetDatabase.load(from: setBaseFile.maps)
        }
    }

    func spawnMonsters(for mapName: String) {
        let spawnManager = SpawnManager(
            monsterDatabase: monsterDatabase,
            monsterSetDatabase: monsterSetDatabase
        )
        monsters = spawnManager.spawnMonsters(for: mapName)
    }
}
