//
//  InfoView.swift
//  Checked
//
//  Created by Larry N on 5/2/21.
//

import SwiftUI

struct InfoView: View {
  @AppStorage("username") var username: String = ""
  @State private var cancelButtonPressed = false

  @Binding var showInfo: Bool

  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        
        // Greeting
        HStack {
          Text("Hello," )
            .customFont(style: .title3, weight: .semibold)
          
          // Change name
          TextField("Enter your name (optional)", text: $username)
            .modifier(CustomTextFieldModifier())
        }
          
        // Subtitle
        Text("Symbols Guide")
          .customFont(weight: .semibold)
          .padding(.vertical)
        
        // List of taskRows with info
        VStack {
          ForEach(InfoTask.guides, id:\.self) { infoTask in
            TaskRow(info: infoTask)
          }
        }
        
        // Dismiss sheet button
        Button("Close") {
          withAnimation { cancelButtonPressed = true }
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation { showInfo = false }
          }
        }
        .buttonStyle(RotateAnimationStyle(bindingBool: $cancelButtonPressed, sfSymbol: .xmark))
        .padding(.bottom)
        
      }
      .padding(.top, 30)
      .padding(.horizontal)
    }
    .modifier(BlurModifier())
  }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
      InfoView(showInfo: .constant(false))
    }
}

