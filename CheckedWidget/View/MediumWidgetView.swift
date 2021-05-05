//
//  MediumWidgetView.swift
//  Checked
//
//  Created by Larry N on 5/3/21.
//

import SwiftUI

struct MediumWidgetView: View {
  let widgetTasks: [WidgetTask]
  
  var body: some View {
    WidgetViewLayout(widgetTasks: widgetTasks) {
      
      VStack {
        HStack {
          VStack(alignment: .leading) {
            if widgetTasks.isEmpty {
              Text("No pending tasks")
                .customFont(style: .caption1)
              
            } else {
              ForEach(widgetTasks.prefix(3)) { task in
                HStack(spacing: 8) {
                  Image(systemName: "circle")
                    .font(.caption)
                    .foregroundColor(task.priorityColor)
                  Text(task.title)
                    .customFont(style: .caption1,
                                weight: .semibold,
                                textColor: task.overdue ? Constants.magenta : Constants.textColor)
                    .lineLimit(1)
                }
                .padding(.bottom, 2)
              }
            }
          }
          .padding(.bottom, 2)
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
          
          VStack(alignment: .trailing) {
            Group {
              Text("Overdue: \(widgetTasks.overdueCount)")
                .customFont(style: .caption1,
                            weight: .semibold,
                            textColor: widgetTasks.overdueCount > 0 ? Constants.magenta : Constants.textColor)
              
              Text("Due today: \(widgetTasks.dueTodayCount)")
                .customFont(style: .caption1, weight: .semibold)

              Text("Due soon: \(widgetTasks.dueSoonCount)")
                .customFont(style: .caption1, weight: .semibold)
            }
            .padding(.bottom, 2)
          }
          .frame(maxHeight: .infinity, alignment: .top)
        }
        
        Spacer()
        
        if widgetTasks.count > 3 {
          Text("+ \(widgetTasks.numberOfExtraTasks) more")
            .customFont(style: .caption1, weight: .semibold)
        }
      }
    }
  }
}

struct MediumViewWidget_Previews: PreviewProvider {
  static var previews: some View {
    MediumWidgetView(widgetTasks: WidgetTask.mockData)
  }
}
