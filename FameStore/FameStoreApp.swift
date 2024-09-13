//
//  FameStoreApp.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//

import SwiftUI
import Firebase


@main
struct FameStoreApp: App {
    let persistenceController = CoreDataManager.shared
    @StateObject var authViewModel = AuthViewModel() // AuthViewModel'i burada başlatıyoruz
    
    init() {
        FirebaseApp.configure()
    }
    

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.persistentContainer.viewContext)
                .environmentObject(authViewModel)
            //HER ZAMAN AYDINLIK MODDA KALMASI ICIN!
                .preferredColorScheme(.light)
        }
    }
}
