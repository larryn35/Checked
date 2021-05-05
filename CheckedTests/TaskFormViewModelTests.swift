//
//  TaskFormViewModelTests.swift
//  CheckedTests
//
//  Created by Larry N on 5/5/21.
//

import XCTest
@testable import Checked

class TaskFormViewModelTests: XCTestCase {
  
  var taskManager: TaskManager!
  var vm: TaskFormViewModel!
  
  override func setUp() {
    super.setUp()
    let coreDataStack = CoreDataTestStack()
    taskManager = TaskManager(viewContext: coreDataStack.viewContext)
    
    vm = TaskFormViewModel(taskManager: taskManager)
    
    vm.title = "Task 1"
    vm.notes = ""
    vm.priority = .low
    vm.deadline = Date().addingTimeInterval(Constants.hour)
    vm.reminderDate = Date().addingTimeInterval(Constants.hour)
    vm.dateCompleted = nil
  }
  
  func testAddTask() {
    vm.addTask()
    let tasks = taskManager.getTasks()
    
    XCTAssertEqual(1, tasks.count)
    XCTAssertEqual("Task 1", tasks[0].title)
  }
  
  func testAddTaskWithDeadline() {
    // First task with showDeadlinePicker set to false
    vm.addTask()

    // Add second task with showDeadlinePicker set to true
    vm.title = "Task 2"
    vm.showDeadlinePicker = true
    vm.addTask()
    
    let tasks = taskManager.getTasks().sortedByDateCreated
    XCTAssertEqual(2, tasks.count)
    
    XCTAssertEqual("Task 2", tasks[1].title)
    XCTAssertNotNil(tasks[1].deadline_)
    XCTAssertTrue(tasks[1].deadlineSet)
  }
  
  func testUpdateTaskNotes() {
    vm.addTask()

    // Retrieve added task
    var tasks = taskManager.getTasks()
    XCTAssertEqual(1, tasks.count)

    // Use update task init
    vm = TaskFormViewModel(tasks[0], taskManager: taskManager)
    
    // Update task's note
    vm.notes = "Updated task"
    vm.updateTask()
    
    // Retrieve task
    tasks = taskManager.getTasks()
    
    XCTAssertEqual(1, tasks.count)
    XCTAssertEqual("Task 1", tasks[0].title)
    XCTAssertEqual("Updated task", tasks[0].notes)
  }
  
  func testUpdateTaskToCancelReminder() {
    vm.reminderDate = Date().addingTimeInterval(Constants.hour)
    vm.showReminderPicker = true
    vm.addTask()

    // Retrieve added task
    var tasks = taskManager.getTasks()
    
    XCTAssertNotNil(tasks[0].reminderDate_)
    XCTAssertTrue(tasks[0].reminderSet)
    
    // Use update task init
    vm = TaskFormViewModel(tasks[0], taskManager: taskManager)
    
    // Save task with showReminderPicker set to false
    vm.showReminderPicker = false
    vm.updateTask()
    
    // Retrieve task
    tasks = taskManager.getTasks()
    
    XCTAssertNil(tasks[0].reminderDate_)
    XCTAssertFalse(tasks[0].reminderSet)
  }
  
  func testFormValidationForEmptyTitle() {
    XCTAssertFalse(vm.showErrorMessage)
    XCTAssertNil(vm.formError)
    
    vm.title = ""
    vm.validateForm()
    
    XCTAssertTrue(vm.showErrorMessage)
    XCTAssertEqual("Task name cannot be blank", vm.formError?.rawValue)
  }
  
  func testFormValidationForDeadlinePassed() {
    XCTAssertFalse(vm.showErrorMessage)
    XCTAssertNil(vm.formError)
    
    vm.deadline = Date().addingTimeInterval(-Constants.hour)
    vm.validateForm()
    
    // Should not change since showDeadlinePicker is still false
    XCTAssertFalse(vm.showErrorMessage)
    XCTAssertNil(vm.formError)
    
    vm.showDeadlinePicker = true
    vm.validateForm()
    
    XCTAssertTrue(vm.showErrorMessage)
    XCTAssertEqual("Deadline has passed", vm.formError?.rawValue)
  }
  
  func testFormValidationForReschedulingReminder() {
    XCTAssertFalse(vm.showErrorMessage)
    XCTAssertNil(vm.formError)
    
    vm.reminderDate = Date().addingTimeInterval(-Constants.hour)
    vm.showReminderPicker = true
    vm.validateForm()
    
    XCTAssertTrue(vm.showErrorMessage)
    XCTAssertEqual("Reminder has passed", vm.formError?.rawValue)
    
    // Reschedule reminder date
    vm.reminderDate = Date().addingTimeInterval(Constants.hour)
    vm.validateForm()
    
    XCTAssertFalse(vm.showErrorMessage)
    XCTAssertNil(vm.formError)
  }
}
