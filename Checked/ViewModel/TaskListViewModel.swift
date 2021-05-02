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
  
  func deleteTask(task: Task) {
    taskManager.deleteTask(task)
  }
}
