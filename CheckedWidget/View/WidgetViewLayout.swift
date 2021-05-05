//
//  WidgetViewLayout.swift
//  CheckedWidgetExtension
//
//  Created by Larry N on 5/4/21.
//

import SwiftUI

struct WidgetViewLayout<Content: View>: View {
  
  let content: Content
  let widgetTasks: [WidgetTask]
  
  init(widgetTasks: [WidgetTask], @ViewBuilder content: () -> Content) {
    self.widgetTasks = widgetTasks
    self.content = content()
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Tasks")
          .customFont(weight: .semibold, textColor: .white)
        Spacer()
        Text("\(widgetTasks.count) total")
          .customFont(weight: .semibold, textColor: .white)
      }
      .padding([.top, .horizontal])
      
      content
        .padding(.horizontal)
        .padding(.vertical,8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Constants.baseAppBG.opacity(0.8))
    }
    .background(Constants.widgetBG.resizable())
  }
}

struct WidgetViewLayout_Previews: PreviewProvider {
    static var previews: some View {
      WidgetViewLayout(widgetTasks: WidgetTask.mockData) {
        Text("Hello")
      }
    }
}
