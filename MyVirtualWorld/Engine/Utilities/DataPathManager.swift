//
//  DataPathManager.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import Foundation

final class DataPathManager {
    static let shared = DataPathManager()

    private(set) var rootPath: URL

    private init() {
        // Ruta base configurable
        let home = FileManager.default.homeDirectoryForCurrentUser
        rootPath = home.appendingPathComponent("Crimson Online")
    }

    func setCustomRoot(path: String) {
        rootPath = URL(fileURLWithPath: path)
    }

    func path(_ relative: String) -> URL {
        return rootPath.appendingPathComponent(relative)
    }
}
