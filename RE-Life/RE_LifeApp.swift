//
//  RE_LifeApp.swift
//  RE-Life
//
//  Created by shafeek macbook pro on 05/03/2026.
//

import SwiftUI

@main
struct RE_LifeApp: App {
    
    @AppStorage("hasSeenWelcome") var hasSeenWelcome: Bool = false
    
    var body: some Scene {
        WindowGroup {
                MainAppView()
            }
        }
    }

