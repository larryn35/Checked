//
//  Constants.swift
//  Checked
//
//  Created by Larry N on 4/30/21.
//

import SwiftUI

extension UIScreen {
  static let screenWidth = UIScreen.main.bounds.size.width
}

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
  
  static let gradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [blue, orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
  
  static let addButton: Image = Image("addButton")
  
  static let hour: Double = 60*60
  static let week: Double = 60*60*24*7
}
