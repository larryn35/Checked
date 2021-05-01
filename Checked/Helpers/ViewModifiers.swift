//
//  ViewModifiers.swift
//  Checked
//
//  Created by Larry N on 4/30/21.
//

import SwiftUI

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
}

struct BlurView: UIViewRepresentable {
  var style: UIBlurEffect.Style = .systemUltraThinMaterial
  
  func makeUIView(context: Context) -> UIVisualEffectView {
    return UIVisualEffectView(effect: UIBlurEffect(style: style))
  }
  
  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    uiView.effect = UIBlurEffect(style: style)
  }
}
