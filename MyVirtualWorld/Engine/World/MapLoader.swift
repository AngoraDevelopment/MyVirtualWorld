//
//  MapLoader.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/9/26.
//

import Foundation

final class MapLoader {
    static func loadMap(named mapFolder: String) -> MapDefinition? {
        let url = DataPathManager.shared.path("Data/Maps/\(mapFolder)/map.json")

        do {
            let data = try Data(contentsOf: url)
            let map = try JSONDecoder().decode(MapDefinition.self, from: data)

            guard map.type == "map" else {
                print("Tipo inválido en map.json: \(map.type)")
                return nil
            }

            guard map.version == 1 else {
                print("Versión de mapa no soportada: \(map.version)")
                return nil
            }

            return map
        } catch {
            print("Error cargando mapa \(mapFolder): \(error)")
            return nil
        }
    }
}
