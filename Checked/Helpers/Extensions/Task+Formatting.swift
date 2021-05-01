//
//  Task+Formatting.swift
//  Checked
//
//  Created by Larry N on 4/30/21.
//

import Foundation

extension Task {
  var title: String {
    title_ ?? "Task"
  }
  
  var taskCompleted: Bool {
    dateCompleted_ != nil
  }
  
  var deadlineSet: Bool {
    deadline_ != nil
  }
  
  var overdue: Bool {
    guard let deadline = deadline_ else { return false }
    return !taskCompleted && deadline < Date()
  }
  
  var reminderSet: Bool {
    reminderDate_ != nil
  }
  
  var deadline: Date {
    deadline_ ?? Date()
  }
  
  var priorityStatus: PriorityType {
    guard let priority = priority_ else { return .low }
    if priority == "High" {
      return .high
    } else if priority == "Medium" {
      return .medium
    } else {
      return .low
    }
  }
}
