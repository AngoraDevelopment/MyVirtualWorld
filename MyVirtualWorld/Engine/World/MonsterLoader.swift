//
//  MonsterLoader.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import Foundation

final class MonsterLoader {

    static func loadMonsterSetBaseFile() -> MonsterSetBaseFile? {
        let url = DataPathManager.shared.path("Data/Monsters/MonsterSetBase.json")

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(MonsterSetBaseFile.self, from: data)
        } catch {
            print("Error cargando MonsterSetBase.json en \(url.path): \(error)")
            return nil
        }
    }
    
    static func loadMonsterFile() -> MonsterFile? {
        let url = DataPathManager.shared.path("Data/Monsters/Monster.json")

        do {
            let data = try Data(contentsOf: url)
            let file = try JSONDecoder().decode(MonsterFile.self, from: data)

            // 🔥 VALIDACIÓN
            guard file.type == "monster" else {
                print("Tipo inválido: \(file.type)")
                return nil
            }

            guard file.version == 1 else {
                print("⚠️ Versión no soportada: \(file.version)")
                return nil
            }

            return file

        } catch {
            print("Error cargando Monster.json: \(error)")
            return nil
        }
    }
}

