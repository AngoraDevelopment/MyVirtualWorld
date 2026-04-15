//
//  GameApp.swift
//  MyVirtualWorld
//
//  Created by Edgardo Ramos on 4/8/26.
//

import SwiftUI

@main
struct GameApp: App {
    var body: some Scene {
        WindowGroup {
            GameView()
                .frame(minWidth: 1200, minHeight: 720)
        }
        .windowResizability(.contentSize)
    }
}
