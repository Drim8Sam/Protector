//
//  protectorApp.swift
//  protector
//
//  Created by err on 12.06.2025.
//

import SwiftUI

@main
struct protectorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
