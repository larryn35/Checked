//
//  TaskFormViewModel.swift
//  Checked
//
//  Created by Larry N on 5/1/21.
//

import SwiftUI

final class TaskFormViewModel: ObservableObject {
  
  // Task properties
  @Published var title = ""
  @Published var taskCompleted = false
  @Published var notes = ""
  @Published var priority: PriorityType = .low
  @Published var deadline = Date().addingTimeInterval(Constants.hour)
  @Published var reminderDate =  Date().addingTimeInterval(Constants.hour)
  @Published var dateCompleted: Date? = nil

  @Published var showDeadlinePicker = false
  @Published var showReminderPicker = false
  @Published var showErrorMessage = false
  @Published var showSaveButton = false

  @Published var formError: FormErrorType? = nil
    
  private let notificationManager = NotificationManager()
  private var taskManager: TaskManagerProtocol
  
  private var currentTask: Task?
  private let newTaskID = UUID()
  
  let dateCreated: String
  
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
  
  enum FormErrorType: String {
    case deadlinePassed = "Deadline has passed"
    case reminderPassed = "Reminder has passed"
    case invalidTitle = "Task name cannot be blank"
  }
}

// MARK: - Variables
extension TaskFormViewModel {
  
  var updating: Bool {
    currentTask != nil
  }
  
  var backgroundImage: Image {
    updating ? Constants.gradientUpdate : Constants.gradientAdd
  }
  
  var formTitle: String {
    updating ? "Edit task" : "Add new task"
  }
  
  var placeholderText: String {
    title.isEmpty ? "Add task" : title
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

// MARK: - Functions
extension TaskFormViewModel {

  // Set local notification for current or new task using UUID
  private func setupNotification() {
    if showReminderPicker {
      
      var taskID: String {
        guard let currentTask = currentTask else { return newTaskID.uuidString }
        return currentTask.uuid
      }
      
      notificationManager.sendNotification(id: taskID,
                                           body: title,
                                           triggerDate: reminderDate)
      
      // Remove any previously set reminders
    } else if let currentTask = currentTask {
      notificationManager.removeNotification(id: currentTask.uuid)
    }
  }
  
  func validateForm() {
    
    if title.isEmpty {
      formError = .invalidTitle
    } else if (!taskCompleted && showDeadlinePicker && deadline < Date()) {
      formError = .deadlinePassed
    } else if (showReminderPicker && reminderDate < Date()) {
      formError = .reminderPassed
    } else {
      formError = nil
    }
    
    if formError != nil {
      withAnimation { showErrorMessage = true }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
        withAnimation { self?.showErrorMessage = false }
      }
    }
  }
  
  // MARK: CRUD
  
  func updateTask() {
    let optionalDeadline: Date? = showDeadlinePicker ? deadline : nil
    let optionalReminder: Date? = showReminderPicker ? reminderDate : nil
    let priority = priority.text
    
    taskManager.updateTask(currentTask!,
                           priority: priority,
                           title: title,
                           notes: notes,
                           deadline: optionalDeadline,
                           reminderDate: optionalReminder)
    
    setupNotification()
  }
  
  func addTask() {
    let optionalDeadline: Date? = showDeadlinePicker ? deadline : nil
    let optionalReminder: Date? = showReminderPicker ? reminderDate : nil
    
    taskManager.addTask(id: newTaskID,
                        priority: priority.text,
                        title: title,
                        notes: notes,
                        reminderDate: optionalReminder,
                        deadline: optionalDeadline)
    
    setupNotification()
  }
  
  func deleteTask() {
    guard let currentTask = currentTask else { return }
    taskManager.deleteTask(currentTask)
    notificationManager.removeNotification(id: currentTask.uuid)
  }
}
