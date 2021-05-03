//
//  Array+Task.swift
//  Checked
//
//  Created by Larry N on 5/2/21.
//

import Foundation

extension Array where Element == Task {
  var activeTasks: [Task] {
    self.filter { !$0.taskCompleted }
  }
  
  var completedTasks: [Task] {
    self.filter { $0.taskCompleted }
  }
  
  var tasksWithDeadline: [Task] {
    self.filter { !$0.taskCompleted && $0.deadlineSet }
  }
  
  var overdue: [Task] {
    self.filter { $0.overdue }
  }
  
  var dueToday: [Task] {
    self.tasksWithDeadline.filter { $0.deadline_!.short == Date().short }
  }
  
  var dueSoon: [Task] {
    self.tasksWithDeadline.filter { $0.deadline_! < Date().addingTimeInterval(Constants.week) }
  }
  
  var sortedByDateCreated: [Task] {
    self.sorted(by: { $0.dateCreated < $1.dateCreated })
  }
  
  var sortedByDeadline: [Task] {
    let tasksWithDeadlines = self.tasksWithDeadline
    let tasksWithoutDeadlines = self.filter { !$0.deadlineSet }
    
    let sortedDeadlines = tasksWithDeadlines.sorted(by: { $0.deadline_! < $1.deadline_! })
    
    return sortedDeadlines + tasksWithoutDeadlines
  }

  var sortedByPriority: [Task] {
    self.sorted(by: { $0.priorityStatus.rawValue > $1.priorityStatus.rawValue })
  }
}