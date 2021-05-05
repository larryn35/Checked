//
//  TaskListViewModelTests.swift
//  CheckedTests
//
//  Created by Larry N on 5/4/21.
//

import XCTest
@testable import Checked

class TaskListViewModelTests: XCTestCase {
  
  var taskManager: TaskManager!
  var vm: TaskListViewModel!
    
  override func setUp() {
    super.setUp()
    let coreDataStack = CoreDataTestStack()
    taskManager = TaskManager(viewContext: coreDataStack.viewContext)
    addTasks()
    
    vm = TaskListViewModel(taskManager: taskManager)
    vm.getTasks()
    
    vm.tasks = vm.tasks.sortedByDateCreated
  }
  
  func testTasksAdded() {
    XCTAssertEqual(7, vm.tasks.count)
    XCTAssertEqual(7, vm.taskList.count)
  }
  
  func testUpdateTaskCompletion() {
    // Starting completion status
    XCTAssertFalse(vm.tasks[6].taskCompleted)
    
    // Mark Task 7 as complete
    vm.updateTaskCompletion(for: vm.tasks[6])
    
    XCTAssertEqual("Task 7", vm.tasks[6].title)
    XCTAssertTrue(vm.tasks[6].taskCompleted)

    // Mark Task 7 as incomplete
    vm.updateTaskCompletion(for: vm.tasks[6])
    
    XCTAssertEqual("Task 7", vm.tasks[6].title)
    XCTAssertFalse(vm.tasks[6].taskCompleted)
  }
  
  func testTasksFilteredByIncomplete() {
    // Mark Task 7 as complete
    vm.updateTaskCompletion(for: vm.tasks[6])

    vm.changeFilter(to: .incomplete)
    
    XCTAssertEqual(6, vm.taskList.count)
    
    // Mark Task 7 as incomplete
    vm.updateTaskCompletion(for: vm.tasks[6])
    
    XCTAssertEqual(7, vm.taskList.count)
    
    let completions: [Bool] = vm.taskList.map { $0.taskCompleted }
    
    // Array should not contain true
    XCTAssertTrue(!completions.contains(true))
  }
  
  func testTasksFilteredByCompleted() {
    // Mark Tasks 4 + 7 as complete
    vm.updateTaskCompletion(for: vm.tasks[6])
    vm.updateTaskCompletion(for: vm.tasks[3])

    vm.changeFilter(to: .completed)

    XCTAssertEqual(2, vm.taskList.count)
    
    let completions: [Bool] = vm.taskList.map { $0.taskCompleted }

    // Array should not contain false
    XCTAssertTrue(!completions.contains(false))
  }
  
  func testTasksFilteredByOverdue() {
    vm.changeFilter(to: .overdue)
    
    XCTAssertEqual(1, vm.taskList.count)
    XCTAssertEqual("Task 6", vm.taskList[0].title)
  }
  
  func testTasksFilteredByDueToday() {
    vm.changeFilter(to: .dueToday)

    XCTAssertEqual(2, vm.taskList.count)
    XCTAssertEqual("Task 4", vm.taskList[0].title)
    XCTAssertEqual("Task 7", vm.taskList[1].title)
  }
  
  func testTasksFilteredByDueThisWeek() {
    vm.changeFilter(to: .thisWeek)

    XCTAssertEqual(1, vm.taskList.count)
    XCTAssertEqual("Task 2", vm.taskList[0].title)
  }
  
  func testTasksSortedByDateCreated() {
    vm.sortType = .dateCreated

    let taskTitles = vm.taskList.map { $0.title }
    let expected = ["Task 1", "Task 2", "Task 3", "Task 4", "Task 5", "Task 6", "Task 7"]
    
    XCTAssertEqual(taskTitles, expected)
    
    let wrongAnswer = ["Task 2", "Task 1", "Task 3", "Task 4", "Task 5", "Task 6", "Task 7"]
    
    XCTAssertFalse(taskTitles == wrongAnswer)
  }
  
  func testTasksSortedByDeadline() {
    vm.sortType = .deadline

    let taskTitles = vm.taskList.map { $0.title }
    let expected = ["Task 6", "Task 4", "Task 7", "Task 2", "Task 3", "Task 1", "Task 5"]
    
    XCTAssertEqual(taskTitles, expected)
  }
  
  func testTasksSortedByPriority() {
    vm.sortType = .priority

    let taskTitles = vm.taskList.map { $0.title }
    let expected = ["Task 3", "Task 5", "Task 2", "Task 6", "Task 1", "Task 4", "Task 7"]
    
    XCTAssertEqual(taskTitles, expected)
  }
  
  
  // For setup
  private func addTasks() {
    taskManager.addTask(id: UUID(),
                        priority: "Low",
                        title: "Task 1",
                        notes: "No deadline",
                        reminderDate: nil,
                        deadline: nil)
    
    taskManager.addTask(id: UUID(),
                        priority: "Medium",
                        title: "Task 2",
                        notes: "Due soon",
                        reminderDate: nil,
                        deadline: Date().addingTimeInterval(Constants.week))
    
    taskManager.addTask(id: UUID(),
                        priority: "High",
                        title: "Task 3",
                        notes: "Due more than a week away",
                        reminderDate: nil,
                        deadline: Date().addingTimeInterval(Constants.week * 2))

    taskManager.addTask(id: UUID(),
                        priority: "Low",
                        title: "Task 4",
                        notes: "Due today",
                        reminderDate: nil,
                        deadline: Date().addingTimeInterval(Constants.hour))

    taskManager.addTask(id: UUID(),
                        priority: "High",
                        title: "Task 5",
                        notes: "This has a reminder",
                        reminderDate: Date().addingTimeInterval(Constants.hour),
                        deadline: nil)
    
    taskManager.addTask(id: UUID(),
                        priority: "Medium",
                        title: "Task 6",
                        notes: "This task is past due",
                        reminderDate: nil,
                        deadline: Date().addingTimeInterval(-Constants.week))
    
    taskManager.addTask(id: UUID(),
                        priority: "Low",
                        title: "Task 7",
                        notes: "This will be completed",
                        reminderDate: nil,
                        deadline: Date().addingTimeInterval(Constants.hour + 10))
  }
}

