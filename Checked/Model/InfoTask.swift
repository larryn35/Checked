//
//  InfoTask.swift
//  Checked
//
//  Created by Larry N on 4/30/21.
//

import Foundation

struct InfoTask {
  let title: String
  var priority: PriorityType = .low
  var deadline: String = ""
  var deadlineSet: Bool = false
  var reminderSet: Bool = false
  var overDue: Bool = false
  
  static let guides = [
  
    InfoTask(title: "Low priority tasks have a blue checkbox"),
    InfoTask(title: "Medium priority tasks have an orange checkbox",
             priority: .medium),
    InfoTask(title: "High priority tasks have a magenta checkbox",
             priority: .high),
    InfoTask(title: "Tasks with a deadline have a calendar button",
             deadline: Date().addingTimeInterval(Constants.hour).shortDeadlineFormat,
             deadlineSet: true),
    InfoTask(title: "Overdue tasks have a magenta border",
             deadline: Date().addingTimeInterval(-Constants.hour).shortDeadlineFormat,
             deadlineSet: true,
             overDue: true),
    InfoTask(title: "Tasks with a reminder set have purple text",
             reminderSet: true),
    InfoTask(title: "Swipe left/right on a task to show edit and delete buttons")
  ]
}

