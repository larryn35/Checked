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
    var widgetTasks: [WidgetTask] = []
    var date = Date()
    
    let viewContext = PersistenceController.shared.viewContext
    
    // Fetch tasks
    var tasks: [Task] {
      let request: NSFetchRequest<Task> = Task.fetchRequest()
      do {
        return try viewContext.fetch(request)
      } catch {
        return []
      }
    }
    
    // Convert tasks to widgetTasks
    for task in tasks {
      if task.dateCompleted_ == nil {
        widgetTasks.append(WidgetTask(task: task))
      }
    }
    
    let entry = TaskEntry(tasks: widgetTasks)
    
    // Array of bool representating whether task has an upcoming deadline
    let pendingDeadlines = tasks.map {
      $0.deadline_ ?? Date().addingTimeInterval(-Constants.hour) > Date()
    }

    // If there are any tasks with an upcoming deadline, refresh widget every 10 minutes
    if pendingDeadlines.contains(true) {
      date = Calendar.current.date(byAdding: .minute, value: 10, to: date)!
      let timeline = Timeline(entries: [entry], policy: .after(date))
      completion(timeline)
      
    } else {
      // Else, upload widget manually when a task is added/updated in the app
      let timeline = Timeline(entries: [entry], policy: .never)
      completion(timeline)
    }
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
