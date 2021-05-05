//
//  TextModifier.swift
//  Checked
//
//  Created by Larry N on 5/4/21.
//

import SwiftUI

struct FontModifier: ViewModifier {
  
  let fontName: String = "Avenir Next"
  
  var style: UIFont.TextStyle
  var weight: Font.Weight
  var textColor: Color
  
  func body(content: Content) -> some View {
    content
      .font(Font.custom(fontName, size: UIFont.preferredFont(forTextStyle: style).pointSize)
              .weight(weight))
      .foregroundColor(textColor)
  }
}

extension View {
  func customFont(style: UIFont.TextStyle = .body, weight: Font.Weight = .regular, textColor: Color = Constants.textColor) -> some View {
    self.modifier(FontModifier(style: style, weight: weight, textColor: textColor))
  }
}
