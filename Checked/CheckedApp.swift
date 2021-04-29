//
//  CheckedApp.swift
//  Checked
//
//  Created by Larry N on 4/29/21.
//

import SwiftUI

@main
struct CheckedApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
