//
//  CheckedWidget.swift
//  CheckedWidget
//
//  Created by Larry N on 5/2/21.
//

// https://github.com/pawello2222/WidgetExamples
// https://stackoverflow.com/questions/63936425/fetch-data-from-coredata-for-ios-14-widget
// https://www.youtube.com/watch?v=NxGZnG8g8_Q

import WidgetKit
import SwiftUI
import CoreData

struct TaskEntry: TimelineEntry {
  let date: Date = Date()
  let tasks: [WidgetTask]
}

struct Provider: TimelineProvider {
  
  // Shown while data is loading, can be redacted
  func placeholder(in context: Context) -> TaskEntry {
    TaskEntry(tasks: WidgetTask.mockData)
  }
  
  // Returns a timeline object that will be displayed in the widget gallery
  func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> ()) {
    let widgetTasks = WidgetTask.mockData
    
    let entry = TaskEntry(tasks: widgetTasks)
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var tasks: [Task] {
      let request: NSFetchRequest<Task> = Task.fetchRequest()
      do {
        return try PersistenceController.shared.viewContext.fetch(request)
      } catch {
        return []
      }
    }
    
    var widgetTasks: [WidgetTask] = []
    
    for task in tasks {
      if task.dateCompleted_ == nil {
        widgetTasks.append(WidgetTask(title: task.title_ ?? "Error", priority: task.priority_ ?? "Low", deadline: task.deadline_))
      }
    }
    
    let entry = TaskEntry(tasks: widgetTasks)
    
    let timeline = Timeline(entries: [entry], policy: .never)
    completion(timeline)
  }
}

struct CheckedWidgetEntryView : View {
  @Environment(\.widgetFamily) private var widgetFamily

  var entry: Provider.Entry
  
  var numberOfExtraTasks: Int {
    entry.tasks.count - 3
  }
  
  var body: some View {
    switch widgetFamily {
    case .systemSmall:
      SmallWidgetView(widgetTasks: entry.tasks)
    case .systemMedium:
      MediumWidgetView(widgetTasks: entry.tasks)
    case .systemLarge:
      LargeWidgetView(widgetTasks: entry.tasks)
    @unknown default:
        fatalError()
    }
  }
}

@main
struct CheckedWidget: Widget {
  let kind: String = "CheckedWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      CheckedWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Checked")
    .description("Keep track of tasks and reminders.")
  }
}

struct CheckedWidget_Previews: PreviewProvider {
  static var previews: some View {
    CheckedWidgetEntryView(entry: TaskEntry(tasks: WidgetTask.mockData))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
