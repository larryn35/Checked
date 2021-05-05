//
//  ViewModifiers.swift
//  Checked
//
//  Created by Larry N on 4/30/21.
//

import SwiftUI

/// For InfoView and ViewLayout. Adds BlurView background and rounded rectangle overlay to view.
struct BlurModifier: ViewModifier {
  func body(content: Content) -> some View {
    return content
      .frame(minWidth: .none, maxWidth: UIScreen.screenWidth, minHeight: .none, maxHeight: .infinity)
      .background(BlurView())
      .cornerRadius(20)
      .overlay(
        RoundedRectangle(cornerRadius: 20)
          .stroke(lineWidth: 2)
          .fill(Color.secondary).opacity(0.2)
      )
      .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 5)
      .edgesIgnoringSafeArea(.bottom)
  }
  
  private struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemUltraThinMaterial
    
    func makeUIView(context: Context) -> UIVisualEffectView {
      return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
      uiView.effect = UIBlurEffect(style: style)
    }
  }
}

/// For Textfields and TaskRows. Adds rounded rectangle background with taskRowBG color with stroke to view. For task rows, set coloredBorder to TRUE to change border to magenta when task is overdue
struct RoundedRectangleWithStrokeStyle: ViewModifier {
  var coloredBorder: Bool? = false
  
  var fillColor: Color {
    if let border = coloredBorder {
      return border ? Constants.magenta : Color.secondary.opacity(0.2)
    } else {
      return Color.secondary.opacity(0.2)
    }
  }
  
  func body(content: Content) -> some View {
    return
      content
      .background(
        RoundedRectangle(cornerRadius: 10)
          .strokeBorder(fillColor, lineWidth: 2)
          .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Constants.taskRowBG))
      )
  }
}

/// Clears textfield background color and adds rounded rectangle style
struct CustomTextFieldModifier: ViewModifier {
  init() {
    UITextView.appearance().backgroundColor = .clear
  }
  
  func body(content: Content) -> some View {
    content
      .customFont()
      .padding(8)
      .modifier(RoundedRectangleWithStrokeStyle())
  }
}
