//
//  SmallWidgetView.swift
//  Checked
//
//  Created by Larry N on 5/3/21.
//

import SwiftUI

struct SmallWidgetView: View {
  var widgetTasks: [WidgetTask]
  
  var body: some View {
    WidgetViewLayout(widgetTasks: widgetTasks) {
      
      VStack(alignment: .leading) {
        if widgetTasks.isEmpty {
          Text("No pending tasks")
            .customFont(style: .caption1)
        } else {
          ForEach(widgetTasks.prefix(3)) { task in
            Text(task.title)
              .customFont(style: .caption1,
                          weight: .semibold,
                          textColor: task.overdue ? Constants.magenta : Constants.textColor)
              .lineLimit(1)
              .padding(.bottom, 2)
          }
          if widgetTasks.count > 3 {
            Text("+ \(widgetTasks.numberOfExtraTasks) more")
              .customFont(style: .caption1, weight: .semibold)
              .padding(.bottom, 2)
          }
        }
      }
    }
  }
}

struct SmallWidgetView_Previews: PreviewProvider {
    static var previews: some View {
      SmallWidgetView(widgetTasks: WidgetTask.mockData)
    }
}
