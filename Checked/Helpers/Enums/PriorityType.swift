//
//  PriorityType.swift
//  Checked
//
//  Created by Larry N on 4/30/21.
//

import Foundation

enum PriorityType: Int, Codable, CaseIterable {
  case low
  case medium
  case high
  
  var text: String {
    switch self {
    case .low:
      return "Low"
    case .medium:
      return "Medium"
    case .high:
      return "High"
    }
  }
}

extension PriorityType: Identifiable {
  var id: String {
    return self.text
  }
}
