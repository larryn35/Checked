//
//  Constants.swift
//  Checked
//
//  Created by Larry N on 4/30/21.
//

import SwiftUI

struct Constants {
  static let gradientHome = Image("gradientHome")
  static let gradientAdd = Image("gradientAdd")
  static let gradientUpdate = Image("gradientUpdate")
  
  static let magenta: Color = Color("customMagenta")
  static let orange: Color = Color("customOrange")
  static let blue: Color = Color("customBlue")
  static let prioritiyColors = [blue, orange, magenta]
  
  static let highPriorityBG: Color = Color("highPriorityBG")
  static let medPriorityBG: Color = Color("medPriorityBG")
  static let lowPriorityBG: Color = Color("lowPriorityBG")
  static let priorityBGColors = [lowPriorityBG, medPriorityBG, highPriorityBG]
  
  static let baseAppBG: Color = Color("appBG")
  static let summaryBG: Color = Color("summaryBG")
  static let taskRowBG: Color = Color("taskRowBG")
  static let textColor: Color = Color("textColor")
  
  static let addButton: Image = Image("addButton")
  
  static let hour: Double = 60*60
  static let week: Double = 60*60*24*7
    
  static let quote: String = "Reach for the stars, so if you fall, you land on a cloud"
  
  // MARK: - Widget
  static let widgetBG = Image("widgetBG")
  static let noPendingTasks = "No pending tasks"
}
