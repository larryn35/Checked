//
//  Persistence.swift
//  Checked
//
//  Created by Larry N on 4/29/21.
//

import CoreData
import WidgetKit

struct PersistenceController {
  static let shared = PersistenceController()
  
  let container: NSPersistentCloudKitContainer
  let viewContext: NSManagedObjectContext
  
  private init() {
    let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.io.github.larryn35.Checked")!
    let storeURL = containerURL.appendingPathComponent("Task.sqlite")
    let description = NSPersistentStoreDescription(url: storeURL)
    description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.io.github.larryn35.Checked")

    container = NSPersistentCloudKitContainer(name: "Checked")
    container.persistentStoreDescriptions = [description]
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    container.viewContext.automaticallyMergesChangesFromParent = true
              
    viewContext = container.viewContext
  }
  
  func save() {
    if viewContext.hasChanges {
      do {
        try viewContext.save()
        WidgetCenter.shared.reloadAllTimelines()
      } catch {
        viewContext.rollback()
        print(error.localizedDescription)
      }
    }
  }
}
