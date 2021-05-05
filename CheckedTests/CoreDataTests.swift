//
//  CheckedTests.swift
//  CheckedTests
//
//  Created by Larry N on 4/29/21.
//

import XCTest
@testable import Checked

class CoreDataTests: XCTestCase {
  
  var taskManager: TaskManager!
  
  private func addTask(title: String = "Task 1") {
    taskManager.addTask(id: UUID(),
                        priority: "Low",
                        title: title,
                        notes: "This a task",
                        reminderDate: nil,
                        deadline: nil)
  }
  
  private func getTask() -> Task? {
    let tasks = taskManager.getTasks().sortedByDateCreated
    guard let task = tasks.first else { return nil }
    return task
  }
  
  override func setUp()  {
    super.setUp()
    let coreDataStack = CoreDataTestStack()
    taskManager = TaskManager(viewContext: coreDataStack.viewContext)
    addTask()
  }

  func testTaskAdded() {
    guard let task = getTask() else { return XCTFail() }
    XCTAssertEqual("Task 1", task.title)
  }
  
  func testTaskUpdated() {
    guard let task = getTask() else { return XCTFail() }
    XCTAssertEqual("Task 1", task.title)
    XCTAssertNil(task.deadline_)
    
    let date = Date()
    taskManager.updateTask(task,
                           priority: "High",
                           title: "Updated task",
                           notes: "New notes",
                           deadline: nil,
                           reminderDate: date)
    
    XCTAssertEqual("Updated task", task.title)
    XCTAssertEqual(date, task.reminderDate_!)
    
    // Verify additional tasks were not added by error
    let tasks = taskManager.getTasks()
    XCTAssertEqual(tasks.count, 1)
  }
  
  func testTaskCompletionUpdated() {
    guard let task = getTask() else { return XCTFail() }
    let date = Date()
    
    XCTAssertNil(task.dateCompleted_)
    XCTAssertFalse(task.taskCompleted)
    
    // Task marked completed
    taskManager.updateTaskCompletion(for: task, to: true)
    
    XCTAssertEqual(date.fullDeadlineFormat, task.dateCompleted_!.fullDeadlineFormat)
    XCTAssertTrue(task.taskCompleted)

    // Task marked incomplete, reset
    taskManager.updateTaskCompletion(for: task, to: false)

    XCTAssertNil(task.dateCompleted_)
    XCTAssertFalse(task.taskCompleted)
  }
  
  func testReminderCanceledWhenTaskCompletionChanged() {
    guard let task = getTask() else { return XCTFail() }
    let date = Date()
    
    taskManager.updateTask(task,
                           priority: "High",
                           title: "Updated task",
                           notes: "New notes",
                           deadline: nil,
                           reminderDate: date)
    
    XCTAssertEqual(date, task.reminderDate_)
    
    taskManager.updateTaskCompletion(for: task, to: true) // Task marked completed
    
    XCTAssertNil(task.reminderDate_)

    taskManager.updateTask(task,
                           priority: "High",
                           title: "Updated task",
                           notes: "New notes",
                           deadline: nil,
                           reminderDate: date)
    
    taskManager.updateTaskCompletion(for: task, to: false) // Task marked incomplete, reset
    
    XCTAssertNil(task.reminderDate_)
  }
  
  func testTaskDeleted() {
    // Add second task
    addTask(title: "Task 2")
    let tasks = taskManager.getTasks()
    
    XCTAssertEqual(tasks.count, 2)
    XCTAssertEqual(tasks[1].title, "Task 2")
    
    // Delete Task 1
    taskManager.deleteTask(tasks[0])
    
    let updatedTasks = taskManager.getTasks()
    
    XCTAssertEqual(updatedTasks.count, 1)
    XCTAssertEqual(updatedTasks[0].title, "Task 2")
  }
}
