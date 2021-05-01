//
//  TaskList.swift
//  Checked
//
//  Created by Larry N on 4/29/21.
//

import SwiftUI

struct TaskList: View {
  @AppStorage("username") var username: String = ""
  @StateObject private var vm = TaskListViewModel()
  @State private var modalType: ModalType? = nil
  
  var body: some View {
    ViewLayout(backgroundImage: Constants.gradientHome) {
      
      // MARK:  Header
      ZStack(alignment: .topTrailing) {
        VStack(alignment: .leading) {
          
          // Text header
          Text("Hello, \(username)")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundColor(.white)
          Text("Reach for the stars, so if you fall, you land on a cloud")
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
          
          Spacer().frame(height: 20)
          
          // Task overview
          summarySubview
        }
      }
      
      // MARK: Body
    } content: {
      ZStack(alignment: .bottom) {
        VStack(spacing: 16) {
          VStack(alignment: .leading, spacing: 10) {
            
            // Filter buttons
            filterButtonsSubview
            
            // Sort buttons
            Button {
              // Sort list by deadline, priority, date created
            } label: {
              Label("Sort list", systemImage: "arrow.up.arrow.down") // Change text based on sort type
                .font(.caption)
                .foregroundColor(Constants.textColor)
            }
          }
          
          // Task list
          ScrollView {
            VStack(spacing: 10) {
              ForEach(vm.tasks) { task in
                TaskRow(taskChecked: {
                  // Task completed
                }, editTask: {
                  modalType = .update(task)
                }, deleteTask: {
                  vm.deleteTask(task: task)
                }, task: task)
              }
            }
          }
          .frame(maxHeight: .infinity, alignment: .top)
        }
        
        // Add button
        Button {
          withAnimation {
            modalType = .newTask
          }
        } label: {
          Constants.addButton
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 70, height: 70, alignment: .center)
            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 5)
        }
      }
      
      // Present sheet
      .fullScreenCover(item: $modalType, onDismiss: vm.getTasks) { $0 }
    }
    .onAppear {
      vm.getTasks()
    }
  }
}

// MARK: - Subviews
extension TaskList {
  
  private var filterButtonsSubview: some View {
    ScrollView(.horizontal) {
      ScrollViewReader { target in
        HStack(spacing: 20) {
          ForEach(FilterType.allCases) { type in
            Button {
              withAnimation {
                // Change filter type
                target.scrollTo(type, anchor: .trailing)
              }
            } label: {
              Text(type.rawValue)
                .font(.subheadline)
                .padding(.vertical, 10)
//                .overlay(RoundedRectangle(cornerRadius: 10)
//                          .fill(Constants.blue)
//                          .frame(height: 2)
//                          .scaleEffect(x: ) // Set scale to 1 if filter is highlighted, 0 otherwise
//                         , alignment: .bottom)
                .padding(.bottom, 5)
            }
            .id(type)
          }
        }
      }
    }
  }
  
  private var summarySubview: some View {
    HStack(alignment: .bottom) {
      VStack(alignment: .leading) {
        Text("Tasks")
          .foregroundColor(Constants.blue)
        
        Group {
          Text("Active: 0")
          Text("Cpmpleted: 0")
        }
        .foregroundColor(Constants.textColor)
      }
      .padding()
      
      VStack(alignment: .leading) {
        Text("Overdue: 0")
          .foregroundColor(Constants.magenta)
        Group {
          Text("Due today: 0")
          Text("Due soon: 0")
        }
        .foregroundColor(Constants.textColor)
      }
      .frame(maxWidth: .infinity)
      .padding()
    }
    .background(RoundedRectangle(cornerRadius: 10)
                  .fill(Constants.summaryBG))
    .overlay(
      RoundedRectangle(cornerRadius: 10)
        .stroke(lineWidth: 2)
        .fill(Color.secondary).opacity(0.2))
  }
}

// MARK: - Preview

struct TaskList_Previews: PreviewProvider {
  static var previews: some View {
    TaskList()
  }
}
