//
//  Date+Formatting.swift
//  Checked
//
//  Created by Larry N on 4/30/21.
//

import Foundation

extension Date {
  //  day of the week, date, and time: Saturday, 05/01/21 @ 3:12 AM
  var fullDeadlineFormat: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MM/dd/yy @ h:mm a"
    return formatter.string(from: self)
  }
  
  // date and time: 05/01/21 @ 3:12 AM
  var shortDeadlineFormat: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd/yy @ h:mm a"
    return formatter.string(from: self)
  }
  
  // time: 3:12 AM
  var time: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter.string(from: self)
  }
  
  //  short:  5/1/21
  var short: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter.string(from: self)
  }
  
  // relative: Time since current date
  var relative: String {
    let formatter = RelativeDateTimeFormatter()
    let relativeDate = formatter.localizedString(for: self, relativeTo: Date())
    return relativeDate
  }
}
