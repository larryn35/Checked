//
//  Array+WidgetTask.swift
//  CheckedWidgetExtension
//
//  Created by Larry N on 5/4/21.
//

import Foundation

extension Array where Element == WidgetTask {
  var numberOfExtraTasksForLargeWidget: Int {
    self.count - 5
  }
  
  var numberOfExtraTasks: Int {
    self.count - 3
  }
  
  var overdueCount: Int {
    self.filter { $0.overdue }.count
  }
  
  var dueTodayCount: Int {
    self.filter { $0.dueToday }.count
  }
  
  var dueSoonCount: Int {
    self.filter { $0.dueSoon }.count
  }
}
