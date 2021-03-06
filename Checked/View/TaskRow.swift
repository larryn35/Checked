//
//  TaskRow.swift
//  Checked
//
//  Created by Larry N on 4/30/21.
//

import SwiftUI

struct TaskRow: View {
  
  // MARK: - Variables
  @ObservedObject var vm: TaskRowViewModel
  
  // For button animations
  @State private var checkButtonTapped = false
  @State private var editButtonTapped = false
  @State private var deleteButtonTapped = false
  
  @State private var showButtons = false
  
  typealias TaskCheckedHandler = () -> Void
  typealias EditTaskHandler = () -> Void
  typealias DeleteTaskHandler = () -> Void
  
  var taskChecked: TaskCheckedHandler
  var editTask: EditTaskHandler
  var deleteTask: DeleteTaskHandler
  
  private let hapticsManager = HapticsManager()
  
  // MARK: - Body
  var body: some View {
    HStack(spacing: 10) {
      
      // MARK: Task completion button
      Button("Check") {
        if checkButtonTapped == false {
          hapticsManager.notification(type: .success)
        } else {
          hapticsManager.impact(style: .light)
        }
        
        withAnimation { checkButtonTapped.toggle() }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
          taskChecked()
        }
      }
      .buttonStyle(RotateAnimationStyle(bindingBool: $checkButtonTapped,
                                        sfSymbol: .checkmark,
                                        fgColor: vm.checkBoxColor))
      
      // MARK: Task title/deadline
      VStack(alignment: .leading) {
        Text(vm.rowText)
          .lineLimit(vm.lineLimit)
          .customFont(style: vm.font, textColor: vm.foregroundColor)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .contentShape(Rectangle())
      .gesture(
        // Drag to reveal edit/delete buttons
        DragGesture().onEnded { _ in
          withAnimation { showButtons.toggle() }
        })
      
      if showButtons {
        // MARK:  Edit task button
        Button("Edit task") {
          hapticsManager.impact(style: .light)
          
          withAnimation { editButtonTapped.toggle() }
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            editButtonTapped = false
            editTask()
          }
        }
        .buttonStyle(CircleFillAnimationStyle(bindingBool: $editButtonTapped,
                                              sfSymbol: .pencil))
        .padding(.horizontal, 8)
        
        // MARK:  Delete task button
        Button("Delete task") {
          hapticsManager.notification(type: .success)
          withAnimation { deleteButtonTapped.toggle() }
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            deleteButtonTapped = false
            deleteTask()
          }
        }
        .buttonStyle(CircleFillAnimationStyle(bindingBool: $deleteButtonTapped,
                                              sfSymbol: .trash))
      }
      
      // MARK: Deadline button
      if vm.deadlineSet && !showButtons {
        Button("deadline") {
          withAnimation { vm.showDeadline.toggle() }
        }
        .buttonStyle(CalendarAnimationStyle(bindingBool: $vm.showDeadline))
      }
    }
    .padding()
    .modifier(RoundedRectangleWithStrokeStyle(coloredBorder: vm.taskOverDue))
    .onAppear {
      checkButtonTapped = vm.taskCompleted
    }
  }
}

// MARK: - Initializers
extension TaskRow {
  
  /// For TaskList
  init(taskChecked: @escaping TaskCheckedHandler,
       editTask: @escaping EditTaskHandler,
       deleteTask: @escaping DeleteTaskHandler,
       task: Task) {
    vm = TaskRowViewModel(task: task)
    self.taskChecked = taskChecked
    self.editTask = editTask
    self.deleteTask = deleteTask
  }
  
  /// Init for InfoView, use InfoTask.guides
  init(info: InfoTask) {
    vm = TaskRowViewModel(infoTask: info)
    taskChecked = {}
    editTask = {}
    deleteTask = {}
  }
}

// MARK: - Preview
struct TaskRow_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 20) {
      TaskRow(info: InfoTask.guides[0])
    }
  }
}
