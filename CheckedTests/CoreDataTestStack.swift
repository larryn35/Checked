//
//  CoreDataTestStack.swift
//  CheckedTests
//
//  Created by Larry N on 4/30/21.
//

import CoreData

struct CoreDataTestStack {
  let container: NSPersistentContainer
  let viewContext: NSManagedObjectContext
  
  init() {
    container = NSPersistentCloudKitContainer(name: "Checked")
    container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")

    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })

    viewContext = container.viewContext
  }
}
