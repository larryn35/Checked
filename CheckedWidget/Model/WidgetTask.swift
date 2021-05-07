//
//  WidgetTask.swift
//  Checked
//
//  Created by Larry N on 5/2/21.
//

import SwiftUI

struct WidgetTask: Identifiable {
  let id: String = UUID().uuidString
  let title: String
  let priority: String
  let deadline: Date?
  
  static var mockData = [
    WidgetTask(title: "Buy groceries", priority: "Low", deadline: Date()),
    WidgetTask(title: "Pay rent", priority: "High", deadline: Date().addingTimeInterval(60*60*24*10)),
    WidgetTask(title: "Vacuum living room", priority: "Medium", deadline: nil),
    WidgetTask(title: "Call mom", priority: "Medium", deadline: nil),
  ]
  
  init(task: Task) {
    title = task.title_ ?? "Error"
    priority = task.priority_ ?? "Low"
    deadline = task.deadline_
  }
  
  init(title: String, priority: String, deadline: Date?) {
    self.title = title
    self.priority = priority
    self.deadline = deadline
  }
}
