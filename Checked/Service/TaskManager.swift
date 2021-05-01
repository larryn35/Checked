//
//  TaskManager.swift
//  Checked
//
//  Created by Larry N on 4/30/21.
//

import Foundation
import CoreData

protocol TaskManagerProtocol {
  func addTask(title: String, deadline: Date?)
  func getTasks() -> [Task]
  func updateTask(_ task: Task, title: String, deadline: Date?)
  func deleteTask(_ task: Task)
}

final class TaskManager: TaskManagerProtocol {
  var viewContext: NSManagedObjectContext = PersistenceController.shared.viewContext

  func addTask(title: String, deadline: Date?) {
    let newTask = Task(context: viewContext)
    newTask.id_ = UUID()
    newTask.title_ = title
    newTask.deadline_ = deadline
    save()
  }
  
  func getTasks() -> [Task] {
    let request: NSFetchRequest<Task> = Task.fetchRequest()
    do {
        return try viewContext.fetch(request)
    } catch {
        return []
    }
  }
  
  func updateTask(_ task: Task, title: String, deadline: Date?) {
    task.title_ = title
    task.deadline_ = deadline
    save()
  }
  
  func deleteTask(_ task: Task) {
    viewContext.delete(task)
    save()
  }
  
  private func save() {
    PersistenceController.shared.save()
  }
}
