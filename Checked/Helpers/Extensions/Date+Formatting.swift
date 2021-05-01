//
//  Date+Formatting.swift
//  Checked
//
//  Created by Larry N on 4/30/21.
//

import Foundation

extension Date {
  //  date and time: Saturday, May 1, 2021 @ 3:12 AM
  var deadlineFormat: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMM d, yyyy @ h:mm a"
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
