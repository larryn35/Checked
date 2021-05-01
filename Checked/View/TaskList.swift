//
//  TaskList.swift
//  Checked
//
//  Created by Larry N on 4/29/21.
//

import SwiftUI

struct TaskList: View {
  @StateObject private var vm = TaskListViewModel()
  
    var body: some View {
      VStack {
        TextField("Task title", text: $vm.title)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        
        Button("Set deadline") {
          vm.showDatePicker.toggle()
        }
        .padding()
        
        if vm.showDatePicker {
          DatePicker("Select date", selection: $vm.deadline)
        }
        
        Button("Add task") {
          vm.addTask()
          vm.getTasks()
        }
        .accentColor(.blue)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 2))
        

        
        List {
          ForEach(vm.tasks) { task in
            VStack(alignment: .leading) {
              Text(task.title_ ?? "Task")
              
              if let deadline = task.deadline_ {
                Text("\(deadline)")
              }
            }
            .padding(.bottom)
          }
          .onDelete(perform: { index in
              vm.deleteTask(at: index)
              vm.getTasks()
          })
        }
      }
      .padding()
      .onAppear { vm.getTasks() }
    }
}

struct TaskList_Previews: PreviewProvider {
    static var previews: some View {
        TaskList()
    }
}
