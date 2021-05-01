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
    taskManager.addTask(title: title,
                        deadline: nil)
  }
  
  private func getTask() -> Task? {
    let tasks = taskManager.getTasks()
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
    taskManager.updateTask(task, title: "Updated task", deadline: date)
    
    XCTAssertEqual("Updated task", task.title)
    XCTAssertEqual(date, task.deadline_!)
    
    // Verify additional tasks were not added by error
    let tasks = taskManager.getTasks()
    XCTAssertEqual(tasks.count, 1)
  }
  
  func testTaskDeleted() {
    addTask(title: "Task 2")
    let tasks = taskManager.getTasks()
    XCTAssertEqual(tasks.count, 2)
    
    XCTAssertEqual(tasks[0].title, "Task 2")
    taskManager.deleteTask(tasks[0])
    
    let updatedTasks = taskManager.getTasks()
    XCTAssertEqual(updatedTasks.count, 1)
    XCTAssertEqual(updatedTasks[0].title, "Task 1")
  }
}
