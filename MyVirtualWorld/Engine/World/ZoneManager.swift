//
//  ZoneManager.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/9/26.
//

import Foundation
import simd

final class ZoneManager {
    private(set) var currentMap: MapDefinition?
    private(set) var loadedZones: [String: Zone] = [:]
    private(set) var currentMapFolder: String?

    private(set) var activeZoneKeys: Set<String> = []
    private(set) var currentPlayerZone: (x: Int, y: Int)?

    func loadMap(named mapFolder: String) -> Bool {
        guard let map = MapLoader.loadMap(named: mapFolder) else {
            return false
        }

        currentMap = map
        currentMapFolder = mapFolder
        loadedZones.removeAll()
        activeZoneKeys.removeAll()
        currentPlayerZone = nil

        return true
    }

    func loadZone(gridX: Int, gridY: Int) -> Zone? {
        guard let mapFolder = currentMapFolder else {
            print("No hay mapa actual cargado")
            return nil
        }

        guard let map = currentMap else {
            print("currentMap es nil")
            return nil
        }

        guard gridX >= 0, gridX < map.zonesX, gridY >= 0, gridY < map.zonesY else {
            return nil
        }

        let key = zoneKey(gridX: gridX, gridY: gridY)

        if let cached = loadedZones[key] {
            return cached
        }

        guard let zone = WorldLoader.loadZone(mapFolder: mapFolder, gridX: gridX, gridY: gridY) else {
            return nil
        }

        loadedZones[key] = zone
        return zone
    }

    func unloadZone(gridX: Int, gridY: Int) {
        let key = zoneKey(gridX: gridX, gridY: gridY)
        loadedZones.removeValue(forKey: key)
        activeZoneKeys.remove(key)
    }

    func unloadAllZones() {
        loadedZones.removeAll()
        activeZoneKeys.removeAll()
    }

    func zoneKey(gridX: Int, gridY: Int) -> String {
        "\(gridX)_\(gridY)"
    }

    func worldPositionForZone(gridX: Int, gridY: Int) -> SIMD3<Float> {
        guard let map = currentMap else { return .zero }

        let origin = map.originVector
        let x = origin.x + Float(gridX) * map.zoneSize
        let z = origin.z + Float(gridY) * map.zoneSize

        return SIMD3<Float>(x, map.defaultGroundY, z)
    }

    func zoneCoordinates(for worldPosition: SIMD3<Float>) -> (x: Int, y: Int)? {
        guard let map = currentMap else { return nil }

        let localX = worldPosition.x - map.originVector.x
        let localZ = worldPosition.z - map.originVector.z

        guard localX >= 0, localZ >= 0 else { return nil }

        let gridX = Int(floor(localX / map.zoneSize))
        let gridY = Int(floor(localZ / map.zoneSize))

        guard gridX >= 0, gridX < map.zonesX, gridY >= 0, gridY < map.zonesY else {
            return nil
        }

        return (gridX, gridY)
    }

    func updateZones(around worldPosition: SIMD3<Float>, radius: Int = 1) -> Bool {
        guard let center = zoneCoordinates(for: worldPosition) else {
            return false
        }

        let zoneChanged = currentPlayerZone?.x != center.x || currentPlayerZone?.y != center.y
        currentPlayerZone = center

        var requiredKeys: Set<String> = []

        for y in (center.y - radius)...(center.y + radius) {
            for x in (center.x - radius)...(center.x + radius) {
                guard let map = currentMap,
                      x >= 0, x < map.zonesX,
                      y >= 0, y < map.zonesY else {
                    continue
                }

                let key = zoneKey(gridX: x, gridY: y)
                requiredKeys.insert(key)

                _ = loadZone(gridX: x, gridY: y)
            }
        }

        let keysToUnload = activeZoneKeys.subtracting(requiredKeys)

        for key in keysToUnload {
            loadedZones.removeValue(forKey: key)
        }

        activeZoneKeys = requiredKeys
        return zoneChanged
    }

    func activeZones() -> [Zone] {
        activeZoneKeys.compactMap { loadedZones[$0] }
    }
}
