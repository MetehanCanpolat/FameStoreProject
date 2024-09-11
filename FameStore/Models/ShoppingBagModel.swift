//
//  ShoppingBagModel.swift
//  FameStore
//
//  Created by Metehan Canpolat on 11.09.2024.
//

import Foundation
import CoreData


struct AddedProduct: Identifiable, Codable {
    var id = UUID()
    var image: String
    var title: String
    var price: Double
}


class CoreDataManager {
    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "CoreData") // YourModelName, Core Data modelinizin adı olmalı.
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to load Core Data stack: \(error)")
            }
        }
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
