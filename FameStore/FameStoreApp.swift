//
//  FameStoreApp.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//

import SwiftUI


@main
struct FameStoreApp: App {
    let persistenceController = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.persistentContainer.viewContext)
        }
    }
}
