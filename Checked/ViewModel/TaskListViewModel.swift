//
//  TaskListViewModel.swift
//  Checked
//
//  Created by Larry N on 4/30/21.
//

import Foundation

final class TaskListViewModel: ObservableObject {
  @Published var tasks: [Task] = []
  @Published var title: String = ""
  @Published var deadline: Date = Date().addingTimeInterval(60*60)
  @Published var showDatePicker = false
  
  let taskManager: TaskManagerProtocol
  
  init(taskManager: TaskManagerProtocol = TaskManager()) {
    self.taskManager = taskManager
  }
  
  func getTasks() {
    tasks = taskManager.getTasks()
  }
  
  func addTask() {
    guard !title.isEmpty else { return }
    var taskDeadline: Date? = nil
    
    if showDatePicker {
      taskDeadline = deadline
    }
    
    taskManager.addTask(title: title, deadline: taskDeadline)
    title = ""
    showDatePicker = false
  }
  
  func deleteTask(task: Task) {
    taskManager.deleteTask(task)
  }
}
