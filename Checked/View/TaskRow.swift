//
//  TaskRow.swift
//  Checked
//
//  Created by Larry N on 4/30/21.
//

import SwiftUI

struct TaskRow: View {
  typealias TaskCheckedHandler = () -> Void
  typealias EditTaskHandler = () -> Void
  typealias DeleteTaskHandler = () -> Void
  
  // MARK: - Variables
  @ObservedObject var vm: TaskRowViewModel
  @State private var showButtons = false
  @State private var checkButtonTapped = false
  @State private var editButtonTapped = false
  @State private var deleteButtonTapped = false
  
  
  var taskChecked: TaskCheckedHandler
  var editTask: EditTaskHandler
  var deleteTask: DeleteTaskHandler
  
    // MARK: - Body
  var body: some View {
    HStack(spacing: 10) {
      
      // MARK: Task completion button
      Button("Check") {
        withAnimation { checkButtonTapped.toggle() }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
          taskChecked()
        }
      }
      
      // MARK: Task title/deadline
      VStack(alignment: .leading) {
        Text(vm.rowText)
          .lineLimit(vm.lineLimit)
          .foregroundColor(vm.foregroundColor)
          .font(vm.font)
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
        Button("edit") {
          withAnimation { editButtonTapped.toggle() }

          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            editButtonTapped = false
            editTask()
          }
        }
        .padding(.horizontal, 8)
        
        // MARK:  Delete task button
        Button("delete") {

          withAnimation { deleteButtonTapped.toggle() }

          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            deleteButtonTapped = false
            deleteTask()
          }
        }
      }
      
      // MARK: Deadline button
      if vm.deadlineSet && !showButtons {
        Button("deadline") {
          withAnimation { vm.showDeadline.toggle() }
        }
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
  init(taskChecked: @escaping TaskCheckedHandler,
       editTask: @escaping EditTaskHandler,
       deleteTask: @escaping DeleteTaskHandler,
       task: Task) {
    vm = TaskRowViewModel(task: task)
    self.taskChecked = taskChecked
    self.editTask = editTask
    self.deleteTask = deleteTask
  }
  
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
