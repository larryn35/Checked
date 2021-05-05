//
//  TaskManager.swift
//  Checked
//
//  Created by Larry N on 4/30/21.
//

import Foundation
import CoreData
import WidgetKit

protocol TaskManagerProtocol {
  func getTasks() -> [Task]
  func addTask(id: UUID, priority: String, title: String, notes: String, reminderDate: Date?, deadline: Date?)
  func updateTask(_ task: Task, priority: String, title: String, notes: String, deadline: Date?, reminderDate: Date?)
  func updateTaskCompletion(for task: Task, to completed: Bool)
  func deleteTask(_ task: Task)
}

final class TaskManager: TaskManagerProtocol {
  var viewContext: NSManagedObjectContext

  init(viewContext: NSManagedObjectContext = PersistenceController.shared.viewContext) {
    self.viewContext = viewContext
  }

  func getTasks() -> [Task] {
    let request: NSFetchRequest<Task> = Task.fetchRequest()
    do {
      return try viewContext.fetch(request)
    } catch {
      return []
    }
  }
  
  func addTask(id: UUID,
               priority: String,
               title: String,
               notes: String,
               reminderDate: Date?,
               deadline: Date?) {
    
    let newTask = Task(context: viewContext)
    newTask.id_ = id
    newTask.dateCreated_ = Date()
    newTask.priority_ = priority
    newTask.title_ = title
    newTask.notes_ = notes
    newTask.reminderDate_ = reminderDate
    newTask.deadline_ = deadline
    
    save()
  }
  
  func updateTask(_ task: Task,
                  priority: String,
                  title: String,
                  notes: String,
                  deadline: Date?,
                  reminderDate: Date?) {
    
    task.priority_ = priority
    task.title_ = title
    task.notes_ = notes
    task.deadline_ = deadline
    task.reminderDate_ = reminderDate
    
    save()
  }
  
  func updateTaskCompletion(for task: Task, to completed: Bool) {
    task.reminderDate_ = nil // Cancel reminder date
    
    if completed {
      task.dateCompleted_ = Date()
    } else {
      task.dateCompleted_ = nil
    }
    
    save()
  }
  
  func deleteTask(_ task: Task) {
    viewContext.delete(task)
    save()
  }
  
  private func save() {
    PersistenceController.shared.save()

    WidgetCenter.shared.reloadAllTimelines()
  }
}
