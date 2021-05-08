![](https://github.com/larryn35/Checked/blob/main/ReadMeResources/Screenshots.png?raw=true)

## About the app

An iOS app that helps you manage and organize your tasks. Features cloud-based storage and the ability to add notes, set deadlines and reminders, and quickly view tasks with the widget. Built with SwiftUI and CloudKit. 

My main focuses when building Checked were UI design and learning to work with CloudKit and WidgetKit.
<br><br>

### Design

The UI of the app was inspired by [Herdetya Priambodo's design](https://dribbble.com/shots/13998970-Simple-Task-App) on dribbble.com. I found Herdetya's use of color and layout to be visually appealing and a clean way to present information. I used Figma to plan my [design](https://www.figma.com/file/yPC9EgzYVC4Wz1Ssk2TSaC/ToDoApp?node-id=0%3A1) and experiment with various color combinations to ensure that the text and symbols were still readable when switching between dark and  light modes. 

The gradients were created using an online wave generator and layered using a SVG editor. To create the semitransparent background /  [glassmorphism](https://uxdesign.cc/glassmorphism-in-user-interfaces-1f39bb1308c9) effect for the task list and form, a `BlurView` was created and applied to the background of the container.

```swift
struct BlurModifier: ViewModifier {
  func body(content: Content) -> some View {
    return content
      .frame(maxWidth: UIScreen.screenWidth, maxHeight: .infinity)
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
  
  private struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemUltraThinMaterial
    
    func makeUIView(context: Context) -> UIVisualEffectView {
      return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
      uiView.effect = UIBlurEffect(style: style)
    }
  }
}
```

<br>

Putting it all together, we get this as the basic layout for the main views - `TaskList` and `TaskForm`.

```swift
struct ViewLayout<Header : View, Content : View>: View {
  
  // [...]

  var body: some View {
    ZStack(alignment: .top) {
      // Gradient (top half of app's background)
      // Light/dark color (bottom half of app's background)
      
      VStack(alignment: .leading) {
        // Title ("Header")
        
        VStack {
          // Task list or form ("Content")
        }
        .modifier(BlurModifier())
      }
    }
  }
}
```

<br>

The button animations are similar in that they use a custom `ButtonStyle` that takes a `@Binding` bool that alerts the modifier when the button is triggered. Once this occurs, the button's properties, such as color or rotation, is changed using ternary operators.

```swift
struct RotateAnimationStyle: ButtonStyle {
  @Binding var bindingBool: Bool
	var fgColor: Color = Constants.textColor

  func makeBody(configuration: Self.Configuration) -> some View {
    Image(systemName: bindingBool ? "checkmark.circle.fill" : "circle")
      .resizable()
      .foregroundColor(fgColor)
      .opacity(bindingBool || configuration.isPressed ? 1 : 0.7)
      .rotationEffect(.degrees(bindingBool ? 0 : -90))
      .frame(width: 20, height: 20, alignment: .center)
      .scaleEffect(configuration.isPressed ? 1.2 : 1)
      .animation(.spring())
  }
}
```

<br>


In the button's `View`, I used `DispatchQueue.main.asyncAfter(deadline: )` to allow the animation to carry out before triggering the main action. 

```swift
struct TaskRow: View {
	@State private var checkButtonTapped = false

  var body: some View {
      Button("Check") {
        withAnimation { checkButtonTapped.toggle() }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
          taskChecked() // Removes task from active tasks list
        }
      }
      .buttonStyle(RotateAnimationStyle(bindingBool: $checkButtonTapped)
	}
}
```

<br>

### CloudKit / Core Data Unit Testing

The app's data is stored in Apple's CloudKit and is automatically synced between devices with Checked and the user's iCloud account. Currently, the app is only supported on the iPhone, but I hope to expand it to the iPad and Apple Watch in the future.

Setting up CloudKit was pretty straightforward and similar to setting up Core Data. CloudKit does require enabling [iCloud and remote notifications capabilities](https://developer.apple.com/documentation/coredata/mirroring_a_core_data_store_with_cloudkit/setting_up_core_data_with_cloudkit). Things became a little more complicated when I tried to integrate widgets into the app, but more on that later.

<br>


At this point, my `PersistenceController` looked like this:

```swift
import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  
  let container: NSPersistentCloudKitContainer
  let viewContext: NSManagedObjectContext
  
  private init() {
    container = NSPersistentCloudKitContainer(name: "Checked")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    container.viewContext.automaticallyMergesChangesFromParent = true
              
    viewContext = container.viewContext
  }
  
  func save() {
    if viewContext.hasChanges {
      do {
        try viewContext.save()
      } catch {
        viewContext.rollback()
        print(error.localizedDescription)
      }
    }
  }
}
```

<br>

I created a `TaskManager` class where I would inject the context and that would handle the CRUD operations. This [Reddit thread by u/Rillieux17](https://www.reddit.com/r/SwiftUI/comments/mw3ktr/core_data_in_swiftui_using_mvvm_design_pattern/) and the [refactored code](https://github.com/Rillieux/Fish/tree/main/Fish) he shared were very helpful for structuring my code to be more testable.

```swift
import Foundation
import CoreData

protocol TaskManagerProtocol {
  // getTasks(), addTask(), updateTask(), updateTaskCompletion(), deleteTask()
}

final class TaskManager: TaskManagerProtocol {
  var viewContext: NSManagedObjectContext

  init(viewContext: NSManagedObjectContext = PersistenceController.shared.viewContext) {
    self.viewContext = viewContext
  }

  func getTasks() -> [Task] {
    let request: NSFetchRequest<Task> = Task.fetchRequest()
    do {
      return try viewContext.fetch(request)
    } catch {
      return []
    }
  }
  
  // addTask(), updateTask(), updateTaskCompletion(), deleteTask(), save()
}

```

<br>


I can then inject `TaskManager` into my view models and fetch and make changes to my tasks from there.

```swift
import SwiftUI

final class TaskListViewModel: ObservableObject {
  @Published var tasks: [Task] = []
  
  private let taskManager: TaskManagerProtocol
 
  init(taskManager: TaskManagerProtocol = TaskManager()) {
    self.taskManager = taskManager

  func getTasks() {
    tasks = taskManager.getTasks()
  }
  
  func updateTaskCompletion(for task: Task) {
    let change = !task.taskCompleted
    taskManager.updateTaskCompletion(for: task, to: change)
  }
  
  func deleteTask(task: Task) {
    taskManager.deleteTask(task)
  }
}
```

<br>

To set up a Core Data for unit testing, I referred to this [video by Swift Arcade](https://www.youtube.com/watch?v=DTz_MFxe9mk). The process involves creating a separate `NSPersistentContainer` for the tests. This container will write data to memory rather than permanent storage. This way, the app and our tests aren't sharing the same context which can lead to overwriting of data. The app will use `PersistenceController` and the tests will use `CoreDataTestStack`.

```swift
struct CoreDataTestStack {
  let container: NSPersistentContainer
  let viewContext: NSManagedObjectContext
  
  init() {
    container = NSPersistentCloudKitContainer(name: "Checked")
    
    // Write data to memory
    container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")

    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })

    viewContext = container.viewContext
  }
}
```

<br>


In the tests, I can inject `CoreDataTestStack().viewContext` into the `TaskManager`.

```swift
import XCTest
@testable import Checked

class CoreDataTests: XCTestCase {
  
  var taskManager: TaskManager!
    
  override func setUp()  {
    super.setUp()
    let coreDataStack = CoreDataTestStack()
    taskManager = TaskManager(viewContext: coreDataStack.viewContext)
    addTask()
  }
  
  private func addTask(title: String = "Task 1") {
    taskManager.addTask(id: UUID(),
                        priority: "Low",
                        title: title,
                        notes: "This a task",
                        reminderDate: nil,
                        deadline: nil)
  }
  
  private func getTask() -> Task? {
    let tasks = taskManager.getTasks()
    guard let task = tasks.first else { return nil }
    return task
  }

  func testTaskAdded() {
    guard let task = getTask() else { return XCTFail() }
    XCTAssertEqual("Task 1", task.title)
  }
}
```

<br>


This allows me to test the CRUD operations in my `TaskManager`, as well as test functions that use `Task` in my view models - such as populating, filtering and sorting the list in the `TaskList`. 

<br>

### WidgetKit

This [article by Anupam Chugh](https://betterprogramming.pub/introducing-ios-14-widgetkit-with-swiftui-a9cc473caa24) has a nice breakdown of the components of `WidgetKit` and how to build one. Here, I'll focus on how I went about retrieving the data from CloudKit and updating my widget.

The widget displays the user's first three active `Tasks` for the small and medium sizes and the first five in the large widget. The medium and large widgets also show a count of `Tasks` that are past due, due today, and due in a week. 

To share data from the app and CloudKit with the widget, I added the `AppGroup` capability. This [video](https://www.youtube.com/watch?v=NxGZnG8g8_Q) and [article](https://useyourloaf.com/blog/sharing-data-with-a-widget/) can help walk through how to do this. I modified the `PersistenceController` so that the database is created in the `AppGroup` container.

```swift
struct PersistenceController {
  // [...]
  
  private init() {
    let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.io.github.larryn35.Checked")!
    let storeURL = containerURL.appendingPathComponent("Task.sqlite")
    let description = NSPersistentStoreDescription(url: storeURL)
    
    container = NSPersistentCloudKitContainer(name: "Checked")
    container.persistentStoreDescriptions = [description]
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    
 		// [...]
}
```

<br>


I would later realize that while the widget was fetching data and refreshing as expected, the app was no longer connecting to CloudKit. Thankfully, this [StackOverflow answer](https://stackoverflow.com/a/62871975) to a similar problem revealed that I needed to set the `cloudKitContainerOptions` for the `NSPersistentStoreDescription`. The `containerIdentifier` is the name of the container that you created or selected when adding the iCloud capability under `Signing and Capabilities`.

```swift
struct PersistenceController {
  // [...]

    let description = NSPersistentStoreDescription(url: storeURL)
    description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.io.github.larryn35.Checked")
  
 	// [...]
}
```

<br>


Since the widget just needs the `Task`'s title, priority label, and deadline date (if present), I created a separate `WidgetTask` model to pass these properties around. This is probably unnecessary since the widget can just access CloudKit and `Task` directly now. As the Use Your Loaf  [article](https://useyourloaf.com/blog/sharing-data-with-a-widget/) mentions, it may be preferable to extract the data needed by the widget in the app, add it to the `AppGroup` container as a plist or JSON file, and have the widget extract and convert it to `WidgetTask` from there. This way, CoreData/CloudKit can be kept out of the `AppGroup`.

The widget refreshes the list:

- When the user enters the app

```swift
import SwiftUI
import WidgetKit

struct TaskList: View {
  // [...]
  
  var body: some View {
    ZStack(alignment: .top) {
      // [...]
    }
    .onAppear {
      vm.getTasks()
    }
    // Refresh list and widget when app becomes active / returns from background
    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
      WidgetCenter.shared.reloadAllTimelines()
      // [...]                                                                                               
    }
  }
}
```

<br>


- When the user adds, updates, checks/unchecks, or deletes a task

```swift
import CoreData
import WidgetKit

struct PersistenceController {

  func save() {
    if viewContext.hasChanges {
      do {
        try viewContext.save()
        // Refresh widget when Task is added, updated, or saved
        WidgetCenter.shared.reloadAllTimelines()
      } catch {
        viewContext.rollback()
        print(error.localizedDescription)
      }
    }
  }
 }
```

<br>


- Automatically every 10 minutes when there is a pending deadline

```swift
struct Provider: TimelineProvider {
  
	// [...]
  
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
    
    // Convert [tasks] to [widgetTasks]
    for task in tasks {
      if task.dateCompleted_ == nil {
        widgetTasks.append(WidgetTask(task: task))
      }
    }
    
    let entry = TaskEntry(tasks: widgetTasks)
    
    // Array of bool representing whether a task has an upcoming deadline
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
```

<br>


## Closing thoughts

- I found planning the design in Figma to be helpful with figuring out how I wanted to present views and pass data between them

- The most challenging part of creating this app was getting CloudKit and the widget to work together.

- Areas for improvement include expanding the app to iPad and WatchOS and separating CloudKit from the widget

<br>

## Other resources

- [Five Stars - Exploring SwiftUI's Button styles](https://www.fivestars.blog/articles/button-styles/)
- [Donny Wals - Setting up a Core Data store for unit tests](https://www.donnywals.com/setting-up-a-core-data-store-for-unit-tests/)
- Swiftful Thinking (YouTube)
  - [SwiftUI Continued Learning #11: How to schedule local push notifications](https://www.youtube.com/watch?v=mG9BVAs8AIo)
  - [SwiftUI Continued Learning #10: How to add haptics (vibrations)](https://www.youtube.com/watch?v=H45bl6e0cNs)
- [Vadim Bulavin - Keyboard Avoidance for SwiftUI Views](https://www.vadimbulavin.com/how-to-move-swiftui-view-when-keyboard-covers-text-field/)
