//
//  LargeWidgetView.swift
//  Checked
//
//  Created by Larry N on 5/3/21.
//

import SwiftUI

struct LargeWidgetView: View {
  let widgetTasks: [WidgetTask]
  
  var body: some View {
    WidgetViewLayout(widgetTasks: widgetTasks) {
      
      VStack {
        HStack {
          DeadlineCard(count: "\(widgetTasks.overdueCount)", type: .overdue)
          DeadlineCard(count: "\(widgetTasks.dueTodayCount)", type: .dueToday)
          DeadlineCard(count: "\(widgetTasks.dueSoonCount)", type: .dueSoon)
        }
        .padding(.bottom, 8)
        
        if widgetTasks.isEmpty {
          Text("No pending tasks")
            .customFont()
          
        } else {
          ForEach(widgetTasks.prefix(5)) { task in
            HStack {
              Image(systemName: "circle")
                .foregroundColor(task.priorityColor)
                .padding(.horizontal, 4)
              
              Text(task.title)
                .customFont(weight: .semibold,
                            textColor: task.overdue ? Constants.magenta : Constants.textColor)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 2)
          }
          
          Spacer()
          
          if widgetTasks.count > 5 {
            Text("+ \(widgetTasks.numberOfExtraTasksForLargeWidget) more")
              .customFont(style: .subheadline, weight: .semibold)
              .padding(.bottom)
          }
        }
      }
    }
  }
}

enum DeadlineType: String {
  case overdue = "overdue"
  case dueToday = "due today"
  case dueSoon = "due soon"
}

struct DeadlineCard: View {
  let count: String
  let type: DeadlineType
  
  var overdueColor: Color {
    count != "0" && type == .overdue ? Constants.magenta : Constants.textColor
  }
  
  var body: some View {
    VStack {
      Text(count)
        .customFont(style: .title3, weight: .semibold, textColor: overdueColor)
      Text(type.rawValue)
        .customFont(style: .caption1, weight: .semibold)
    }
    .frame(maxWidth: .infinity)
    .padding(4)
  }
}


struct LargeWidgetView_Previews: PreviewProvider {
  static var previews: some View {
    LargeWidgetView(widgetTasks: WidgetTask.mockData)
  }
}
