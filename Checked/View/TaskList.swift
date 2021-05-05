//
//  TaskList.swift
//  Checked
//
//  Created by Larry N on 4/29/21.
//

import SwiftUI
import WidgetKit

struct TaskList: View {
  @AppStorage("username") var username: String = ""
  @StateObject private var vm = TaskListViewModel()
  @State private var modalType: ModalType? = nil
  @State private var showInfo = false
  
  private let hapticsManager = HapticsManager()
  
  var body: some View {
    ZStack(alignment: .top) {
      ViewLayout(backgroundImage: Constants.gradientHome) {
        
        // MARK:  Header
        ZStack(alignment: .topTrailing) {
          Button("Info") {
            hapticsManager.impact(style: .soft)
            withAnimation { showInfo.toggle() }
          }
          .buttonStyle(CircleFillAnimationStyle(bindingBool: $showInfo,
                                                sfSymbol: .info))
          
          VStack(alignment: .leading) {
            // Name + Quote
            Text("Hello, \(username)")
              .customFont(style: .largeTitle, weight: .semibold, textColor: Color.white)
            Text(Constants.quote)
              .customFont(style: .caption1, weight: .semibold, textColor: Color.white)

            Spacer().frame(height: 20)
            
            // Task overview
            summarySubview
          }
        }
        
        // MARK: - Body
      } content: {
        ZStack(alignment: .bottom) {
          VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 10) {
              
              // MARK: Filter buttons
              filterButtonsSubview
              
              // MARK: Sort button
              Button {
                hapticsManager.impact(style: .soft)
                vm.changeSort()
                
              } label: {
                // Change text based on sort type
                Label("Sorted by: \(vm.sortType.rawValue)", systemImage: "arrow.up.arrow.down")
                  .customFont(style: .caption1)
              }
              .accentColor(Constants.textColor)
            }
            
            // MARK: Task list
            ScrollView {
              VStack(spacing: 10) {
                ForEach(vm.taskList) { task in
                  TaskRow(
                    taskChecked: {
                    vm.updateTaskCompletion(for: task)
                    vm.getTasks()},
                    
                    editTask: {
                    modalType = .update(task)},
                    
                    deleteTask: {
                    vm.deleteTask(task: task)
                    vm.getTasks()},
                    
                    task: task)
                }
              }
              
              Spacer().frame(height: 60)
            }
            .frame(maxHeight: .infinity, alignment: .top)
          }
          
          // MARK: Add button
          Button {
            hapticsManager.impact(style: .light)
            withAnimation { modalType = .newTask }
          } label: {
            Constants.addButton
              .resizable()
          }
          .buttonStyle(OffsetAnimationStyle())
        }
        
        // Present sheet
        .fullScreenCover(item: $modalType, onDismiss: vm.getTasks) { $0 }
      }
      
      // MARK: InfoView
      if showInfo {
        InfoView(showInfo: $showInfo)
          .transition(.move(edge: .bottom))
      }
    }
    .onAppear {
      vm.getTasks()
    }
    
    // Refresh list and widget when app becomes active / returns from background
    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
      NotificationManager().removeBadge()
      WidgetCenter.shared.reloadAllTimelines()
      vm.getTasks()
    }
  }
}

// MARK: - Subviews
extension TaskList {
  
  // Display filter options
  private var filterButtonsSubview: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 20) {
        ForEach(FilterType.allCases) { type in
          Button {
            hapticsManager.impact(style: .soft)
            withAnimation { vm.changeFilter(to: type) }
          } label: {
            Text(type.rawValue)
              .customFont(style: .subheadline)
              .padding(.vertical, 10)
              // Display underline for current filter option
              .overlay(RoundedRectangle(cornerRadius: 10)
                        .fill(Constants.blue)
                        .frame(height: 2)
                        .scaleEffect(x: vm.filterUnderlineScale(for: type))
                       , alignment: .bottom)
              .padding(.bottom, 5)
          }
          .accentColor(Constants.textColor)
        }
      }
    }
  }
  
  // Display information about pending and completed tasks
  private var summarySubview: some View {
    HStack(alignment: .bottom) {
      VStack(alignment: .leading) {
        Text("Tasks")
          .customFont(style: .subheadline,textColor: Constants.blue)
        
        Group {
          Text(vm.activeTasksString)
          Text(vm.completedTasksString)
        }
        .customFont(style: .subheadline)
      }
      .padding()
      
      VStack(alignment: .leading) {
        Text(vm.overdueTasksString)
          .customFont(style: .subheadline, textColor: vm.overdueTaskColor)
        Group {
          Text(vm.dueTodayString)
          Text(vm.dueSoonString)
        }
        .customFont(style: .subheadline)
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
