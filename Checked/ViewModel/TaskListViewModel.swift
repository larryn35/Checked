//
//  TaskListViewModel.swift
//  Checked
//
//  Created by Larry N on 4/30/21.
//

import SwiftUI

final class TaskListViewModel: ObservableObject {
  @Published var tasks: [Task] = []
  @Published var title: String = ""
  @Published var deadline: Date = Date().addingTimeInterval(60*60)
  @Published var showDatePicker = false
  @Published var filterType: FilterType = .incomplete
  @Published var sortType: SortType = .dateCreated
  
  let taskManager: TaskManagerProtocol
  
  init(taskManager: TaskManagerProtocol = TaskManager()) {
    self.taskManager = taskManager
  }
}

// MARK: - Variables
extension TaskListViewModel {
  var taskList: [Task] {
    var displayedList = tasks
    
    switch filterType {
    case .incomplete:
      displayedList = displayedList.activeTasks
    case .completed:
      displayedList = displayedList.completedTasks
    case .overdue:
      displayedList = displayedList.overdue
    case .dueToday:
      displayedList = displayedList.dueToday
    case .thisWeek:
      displayedList = displayedList.dueSoon
    case .all:
      print("all")
    }
    
    switch sortType {
    case .dateCreated:
      return displayedList.sortedByDateCreated
    case .deadline:
      return displayedList.sortedByDeadline
    case .priority:
      return displayedList.sortedByPriority
    }
  }
  
  var activeTasksString: String {
    "Active: \(tasks.activeTasks.count)"
  }
  var completedTasksString: String {
    "Completed: \(tasks.completedTasks.count)"
  }
  var overdueTasksString: String {
    "Overdue: \(tasks.overdue.count)"
  }
  var overdueTaskColor: Color {
    tasks.overdue.isEmpty ? Constants.textColor : Constants.magenta
  }
  var dueTodayString: String {
    "Day today: \(tasks.dueToday.count)"
  }
  var dueSoonString: String {
    "Due soon: \(tasks.dueSoon.count)"
  }
}
 
// MARK: - Functions
extension TaskListViewModel {
  func changeFilter(to filter: FilterType) {
    filterType = filter
  }
  
  func changeSort() {
    withAnimation {
      if sortType == .dateCreated {
        sortType = .deadline
      } else if sortType == .deadline {
        sortType = .priority
      } else {
        sortType = .dateCreated
      }
    }
  }
  
  func filterUnderlineScale(for type: FilterType) -> CGFloat {
    filterType == type ? 1 : 0
  }
  
  func getTasks() {
    tasks = taskManager.getTasks()
  }
  
  func updateTaskCompletion(for task: Task) {
    let change = !task.taskCompleted
    taskManager.updateTaskCompletion(for: task, to: change)
  }
  
  func deleteTask(task: Task) {
    taskManager.deleteTask(task)
  }
}
