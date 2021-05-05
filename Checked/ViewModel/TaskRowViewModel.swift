//
//  TaskRowViewModel.swift
//  Checked
//
//  Created by Larry N on 4/30/21.
//

import SwiftUI

final class TaskRowViewModel: ObservableObject {
  @Published var showDeadline = false

  var taskTitle: String
  var taskPriority: PriorityType
  var taskCompleted: Bool
  var deadlineSet: Bool
  var taskDeadline: String
  var taskOverDue: Bool
  var reminderSet: Bool
  var infoView: Bool

  /// For TaskList
  init(task: Task) {
    taskTitle = task.title
    taskPriority = task.priorityStatus
    taskCompleted = task.taskCompleted
    deadlineSet = task.deadlineSet
    taskDeadline = task.deadline.shortDeadlineFormat
    taskOverDue = task.overdue
    reminderSet = task.reminderSet
    infoView = false
  }
  
  /// Init for InfoView, use InfoTask.guides
  init(infoTask: InfoTask) {
    taskTitle = infoTask.title
    taskPriority = infoTask.priority
    taskCompleted = false
    deadlineSet = infoTask.deadlineSet
    taskDeadline = infoTask.deadline
    taskOverDue = infoTask.overDue
    reminderSet = infoTask.reminderSet
    infoView = true
  }
}

// MARK: - Variables
extension TaskRowViewModel {
  
  var rowText: String {
    showDeadline ? "Due: \(taskDeadline)" : taskTitle
  }
  
  var lineLimit: Int {
    infoView ? 2 : 1
  }
  
  var foregroundColor: Color {
    reminderSet ? Constants.blue : Constants.textColor
  }
  
  var font: UIFont.TextStyle {
    infoView ? .caption1 : .body
  }
  
  var checkBoxColor: Color {
    Constants.prioritiyColors[taskPriority.rawValue]
  }
}
