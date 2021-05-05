//
//  WidgetTask+Extension.swift
//  CheckedWidgetExtension
//
//  Created by Larry N on 5/4/21.
//

import SwiftUI

extension WidgetTask {
  var overdue: Bool {
    guard let deadline = deadline else { return false}
    return deadline < Date()
  }
  
  var dueToday: Bool {
    guard let deadline = deadline else { return false}
    return deadline.short == Date().short
  }
  
  var dueSoon: Bool {
    guard let deadline = deadline else { return false}
    return deadline.short != Date().short && deadline < Date().addingTimeInterval(604800) // Seconds in a week
  }
  
  var priorityColor: Color {
    switch priority {
    case "Low":
      return Constants.blue
      
    case "Medium":
      return Constants.orange
      
    default:
      return Constants.magenta
    }
  }
}
