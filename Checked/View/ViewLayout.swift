//
//  ViewLayout.swift
//  Checked
//
//  Created by Larry N on 4/30/21.
//

import SwiftUI

struct ViewLayout<Header : View, Content : View>: View {
  
  let backgroundImage: Image
  let header: Header
  let content: Content
  
  init(
    backgroundImage: Image,
    @ViewBuilder header: () -> Header,
    @ViewBuilder content: () -> Content
  ) {
    self.backgroundImage = backgroundImage
    self.header = header()
    self.content = content()
  }

  var body: some View {
    ZStack(alignment: .top) {
      gradient
      
      VStack(alignment: .leading) {
        header
          .padding()
        
        VStack {
          content
            .padding(.horizontal)
          
          Spacer()
            .frame(height: 20)
        }
        .modifier(BlurModifier())
      }
    }
  }
}

extension ViewLayout {
  private var gradient: some View {
    ZStack(alignment: .top) {
      Constants.baseAppBG
        .edgesIgnoringSafeArea(.bottom)
        .zIndex(-20)
      
      backgroundImage
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: UIScreen.screenWidth, alignment: .topLeading)
        .edgesIgnoringSafeArea(.all)
        .zIndex(-10)
    }
  }
}


struct ViewContainer_Previews: PreviewProvider {
    static var previews: some View {
      ViewLayout(backgroundImage: Constants.gradientHome) {
        Text("Hello")
      } content: {
        Text("World")
      }
    }
}
