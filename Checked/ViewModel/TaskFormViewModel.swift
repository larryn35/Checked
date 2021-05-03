//
//  TaskFormViewModel.swift
//  Checked
//
//  Created by Larry N on 5/1/21.
//

import SwiftUI

final class TaskFormViewModel: ObservableObject {
  
  @Published var title = ""
  @Published var taskCompleted = false
  @Published var notes = ""
  @Published var deadline = Date().addingTimeInterval(Constants.hour)
  @Published var reminderDate =  Date().addingTimeInterval(Constants.hour)
  @Published var showDeadlinePicker = false
  @Published var showReminderPicker = false
  @Published var priority: PriorityType = .low
  @Published var dateCompleted: Date? = nil
  @Published var showSaveButton = false
  
  var taskManager: TaskManagerProtocol
  var currentTask: Task?
  var newTaskID = UUID()
  
  // Setup new task
  init(taskManager: TaskManagerProtocol = TaskManager()) {
    self.taskManager = taskManager
    dateCreated = Date().fullDeadlineFormat
  }
  
  // Setup current task update
  init(_ currentTask: Task, taskManager: TaskManagerProtocol = TaskManager()) {
    self.currentTask = currentTask
    self.dateCreated = currentTask.dateCreated.fullDeadlineFormat
    self.title = currentTask.title
    self.taskCompleted = currentTask.taskCompleted
    self.notes = currentTask.notes
    self.showDeadlinePicker = currentTask.deadlineSet
    self.showReminderPicker = currentTask.reminderSet
    
    for priority in PriorityType.allCases {
      if currentTask.priority_ == priority.text {
        self.priority = priority
      }
    }
    
    if let reminderDate = currentTask.reminderDate_, reminderDate > Date() {
      self.reminderDate = reminderDate
    }
    
    if let dateCompletedForCurrent = currentTask.dateCompleted_ {
      self.dateCompleted = dateCompletedForCurrent
    }
    
    if let currentDeadline = currentTask.deadline_ {
      self.deadline = currentDeadline
    }
    
    self.taskManager = taskManager
  }
  
  let dateCreated: String
  
  var updating: Bool {
    currentTask != nil
  }
  
  var backgroundImage: Image {
    updating ? Constants.gradientUpdate : Constants.gradientAdd
  }
  
  var isDisabled: Bool {
    title.isEmpty ||
      (!taskCompleted && deadline < Date()) ||
      (showReminderPicker && reminderDate < Date())
  }
  
  var formTitle: String {
    updating ? "Edit task" : "Add new task"
  }
  
  var deadlineText: String {
    guard showDeadlinePicker else { return "Set deadline" }
    
    if deadline < Date() {
      return "Deadline was \(deadline.relative)"
    } else {
      return "Deadline is \(deadline.relative)"
    }
  }
  
  var reminderText: String {
    guard showReminderPicker else { return "Set reminder" }
    
    if reminderDate < Date() {
      return "Reschedule reminder"
    } else {
      return "Will remind \(reminderDate.relative)"
    }
  }
  
  var completionIcon: String {
    taskCompleted ? "checkmark.circle" : "circle"
  }
  
  var completionString: String {
    taskCompleted ? "completed" : "incomplete"
  }
  
  var completionIconColor: Color {
    taskCompleted ? .purple : .white
  }
  
  var dateCompletedText: String {
    return dateCompleted?.fullDeadlineFormat ?? Date().fullDeadlineFormat
  }
}

extension TaskFormViewModel {

  func updateToDo() {
    let optionalDeadline: Date? = showDeadlinePicker ? deadline : nil
    let optionalReminder: Date? = showReminderPicker ? reminderDate : nil
    let priority = priority.text
    
    taskManager.updateTask(currentTask!,
                           priority: priority,
                           title: title,
                           notes: notes,
                           deadline: optionalDeadline,
                           reminderDate: optionalReminder)
  }
  
  func addToDo() {
    let optionalDeadline: Date? = showDeadlinePicker ? deadline : nil
    let optionalReminder: Date? = showReminderPicker ? reminderDate : nil
    
    taskManager.addTask(id: newTaskID,
                        priority: priority.text,
                        title: title,
                        notes: notes,
                        reminderDate: optionalReminder,
                        deadline: optionalDeadline)
  }
  
  func deleteToDo() {
    guard let currentTask = currentTask else { return }
    taskManager.deleteTask(currentTask)
  }
}
