//
//  WorldLoader.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import Foundation

final class WorldLoader {
    static func loadZone(mapFolder: String, gridX: Int, gridY: Int) -> Zone? {
        let url = DataPathManager.shared.path(
            "Data/Maps/\(mapFolder)/zones/zone_\(gridX)_\(gridY).json"
        )

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(Zone.self, from: data)
        } catch {
            print("Error cargando zona \(gridX),\(gridY) de \(mapFolder): \(error)")
            return nil
        }
    }
}
