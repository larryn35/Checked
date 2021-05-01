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
    taskDeadline = task.deadline.deadlineFormat
    taskOverDue = task.overdue
    reminderSet = task.reminderSet
    infoView = false
  }
  
  // For InfoView
  init(infoTask: InfoTask) {
    taskTitle = infoTask.title
    taskPriority = infoTask.priority
    taskCompleted = true
    deadlineSet = infoTask.deadlineSet
    taskDeadline = infoTask.deadline
    taskOverDue = infoTask.overDue
    reminderSet = infoTask.reminderSet
    infoView = true
  }
  
  var rowText: String {
    showDeadline ? taskDeadline : taskTitle
  }
  
  var lineLimit: Int {
    infoView ? 2 : 1
  }
  
  var foregroundColor: Color {
    reminderSet ? Constants.blue : Constants.textColor
  }
  
  var font: Font {
    infoView ? .caption : .headline
  }
}
