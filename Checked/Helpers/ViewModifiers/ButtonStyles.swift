//
//  ButtonStyles.swift
//  Checked
//
//  Created by Larry N on 5/2/21.
//

import SwiftUI

enum RotateSymbol {
  case checkmark
  case xmark
}

/// For checkboxes and cancel buttons - Rotates and changes sfSymbol to fill when bindingBool is true
struct RotateAnimationStyle: ButtonStyle {
  @Binding var bindingBool: Bool
  var sfSymbol: RotateSymbol
  
  var startingAngle: Double = -90
  var fgColor: Color = Constants.textColor
  
  var size: CGFloat {
    sfSymbol == .checkmark ? 20 : 30
  }
  
  var sfSymbolOriginal: String {
    sfSymbol == .checkmark ? "circle" : "xmark.circle"
  }
  
  var sfSymbolFinal: String {
    sfSymbol == .checkmark ? "checkmark.circle.fill" : "xmark.circle.fill"
  }

  func makeBody(configuration: Self.Configuration) -> some View {
    Image(systemName: bindingBool ? sfSymbolFinal : sfSymbolOriginal)
      .resizable()
      .foregroundColor(fgColor)
      .opacity(bindingBool || configuration.isPressed ? 1 : 0.7)
      .rotationEffect(.degrees(bindingBool ? 0 : startingAngle))
      .frame(width: size, height: size, alignment: .center)
      .scaleEffect(configuration.isPressed ? 1.2 : 1)
      .animation(.spring())
  }
}

/// For deadline and reminder buttons. Increase size of symbol and changes foreground color from textColor to fgColor when bindingBool is true
struct CalendarAnimationStyle: ButtonStyle {
  @Binding var bindingBool: Bool
  
  var sfSymbol: String = "calendar"
  var fgColor: Color = Constants.blue
  var size: CGFloat = 20
  var alignment: Alignment = .center

  func makeBody(configuration: Self.Configuration) -> some View {
    
    HStack {
      Image(systemName: sfSymbol)
        .resizable()
        .foregroundColor(bindingBool ? fgColor : Constants.textColor)
        .frame(width: size, height: size, alignment: .center)
        .scaleEffect(bindingBool || configuration.isPressed ? 1.2 : 1)
        .opacity(bindingBool || configuration.isPressed ? 1 : 0.7)
        .animation(.spring())
    }
    .frame(width: 50, alignment: alignment)
    .contentShape(Rectangle())
  }
}

enum SpringAnimationIcons: String {
  case pencil = "pencil.circle"
  case trash = "trash.circle"
  case folder = "folder.circle"
  case info = "info.circle"
}

/// Changes sfSymbol to fill when bindingBool is true
struct CircleFillAnimationStyle: ButtonStyle {
  @Binding var bindingBool: Bool
  private let yOffset: CGFloat = -3
  
  var sfSymbol: SpringAnimationIcons
  var fgColor: Color {
    switch sfSymbol {
    case .pencil:
      return Constants.orange
    case .trash:
      return Constants.magenta
    case .folder:
      return Constants.orange
    case .info:
      return Color(#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1))
    }
  }
  
  var size: CGFloat {
    sfSymbol == .info || sfSymbol == .folder ? 30 : 20
  }
  
  var filledSymbol: String {
    sfSymbol.rawValue + ".fill"
  }
  
  func makeBody(configuration: Self.Configuration) -> some View {
    return Image(systemName: bindingBool ? filledSymbol : sfSymbol.rawValue)
      .resizable()
      .foregroundColor(fgColor)
      .offset(x: 0, y: bindingBool ? yOffset : 0)
      .frame(width: size, height: size, alignment: .center)
      .scaleEffect(configuration.isPressed ? 1.2 : 1)
      .opacity(bindingBool || configuration.isPressed ? 1 : 0.7)
      .animation(.spring())
      .transition(AnyTransition.opacity.combined(with: .move(edge: .trailing)))
  }
}

/// For info and add buttons. Offset and scales button on press
struct OffsetAnimationStyle: ButtonStyle {
  
  var size: CGFloat = 70
  let offset: CGFloat = -3
  
  func makeBody(configuration: Self.Configuration) -> some View {
    return configuration.label
      .aspectRatio(contentMode: .fit)
      .frame(width: size, height: size, alignment: .center)
      .offset(y: configuration.isPressed ? offset : 0)
      .scaleEffect(configuration.isPressed ? 1.1 : 1)
      .opacity(configuration.isPressed ? 0.8 : 1)
      .animation(.spring())
      .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 5)
  }
}
