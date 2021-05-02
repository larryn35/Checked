//
//  FilterType.swift
//  Checked
//
//  Created by Larry N on 4/30/21.
//

import Foundation

enum FilterType: String {
  case incomplete = "Active"
  case overdue = "Overdue"
  case dueToday = "Due today"
  case thisWeek = "Due soon"
  case completed = "Completed"
  case all = "All tasks"
}

extension FilterType: CaseIterable, Identifiable {
  var id: String {
    switch self {
    default: return self.rawValue
    }
  }
}
