//
//  WidgetTask.swift
//  Checked
//
//  Created by Larry N on 5/2/21.
//

import Foundation

struct WidgetTask: Identifiable {
  let id: String = UUID().uuidString
  let title: String
  let priority: String
  let deadline: Date?
  
  static var preview = WidgetTask(title: "Buy milk", priority: "Low", deadline: Date())
}
