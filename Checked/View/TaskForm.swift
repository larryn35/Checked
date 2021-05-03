//
//  TaskForm.swift
//  Checked
//
//  Created by Larry N on 5/1/21.
//

import SwiftUI
import Combine

struct TaskForm: View {
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var formVM: TaskFormViewModel
  @State private var keyBoardDisplayed: Bool = false
  @State private var showDeadlinePicker: Bool = false
  @State private var cancelButtonPressed: Bool = false
  @State private var saveButtonPressed: Bool = false
  
  var body: some View {
    ViewLayout(backgroundImage: formVM.backgroundImage) {
      
      // MARK: - Header
      Text(formVM.formTitle)
        .font(.largeTitle)
        .fontWeight(.semibold)
        .foregroundColor(.white)
        .opacity(keyBoardDisplayed ? 0.1 : 1)
      
      // MARK: - Body
    } content: {
      VStack(alignment: .leading, spacing: 20) {
        
        // Priority status buttons
        HStack {
          ForEach(PriorityType.allCases) { status in
            Button {
              formVM.priority = status
            } label: {
              Text(status.text)
                .font(.caption)
                .foregroundColor(Constants.prioritiyColors[status.rawValue])
                .frame(width: 70, height: 20)
                .background(
                  RoundedRectangle(cornerRadius: 10)
                    .fill(Constants.priorityBGColors[status.rawValue])
                    .overlay(RoundedRectangle(cornerRadius: 10)
                              .stroke(Constants.prioritiyColors[status.rawValue], lineWidth: 0.5))
                )
                .opacity(formVM.priority == status ? 1 : 0.3)
            }
          }
        }
        .padding(.top)
        
        // Date created
        Text("Date created: \(formVM.dateCreated)")
          .font(.subheadline)
          .fontWeight(.semibold)
        
        // Edit task title
        VStack(alignment:.leading) {
          Text("Task")
            .font(.subheadline)
            .fontWeight(.semibold)
          
          TextField(formVM.title, text: $formVM.title)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        
        // Edit task note
        VStack(alignment:.leading) {
          HStack {
            Text("Description")
              .font(.subheadline)
              .fontWeight(.semibold)
            
            // Dismiss keyboard button
            if keyBoardDisplayed {
              Button {
                hideKeyboard()
              } label: {
                Label("Dismiss keyboard", systemImage: "keyboard.chevron.compact.down")
                  .font(.caption)
                  .foregroundColor(Constants.orange)
                  .frame(maxWidth: .infinity, alignment: .trailing)
              }
            }
          }
          .onReceive(Publishers.keyboardDisplayed) { (status) in
            keyBoardDisplayed = status
          }
          
          TextField(formVM.notes, text: $formVM.notes)
            .textFieldStyle(RoundedBorderTextFieldStyle())

        }
        
        if !formVM.taskCompleted {
          // Set deadline
          DatePickerView(showDatePicker: $formVM.showDeadlinePicker,
                         text: formVM.deadlineText,
                         date: $formVM.deadline)
          
          // Set reminder
          DatePickerView(showDatePicker: $formVM.showReminderPicker,
                         text: formVM.reminderText,
                         date: $formVM.reminderDate)
          
          
        } else {
          // Task completed
          Text("Date completed: \(formVM.dateCompletedText)")
            .font(.subheadline)
            .fontWeight(.semibold)
            .padding(.bottom)
        }
        
        Spacer()
        
        HStack(spacing: 60) {
          cancelButton
          saveButton
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom)
      }
    }
  }
}

// MARK: - Subviews
extension TaskForm {
  private var cancelButton: some View {
    VStack(spacing: 5) {
      Button("cancel") {
        
        withAnimation { cancelButtonPressed.toggle() }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
          presentationMode.wrappedValue.dismiss()
        }
      }
      
      Text("cancel")
        .foregroundColor(Constants.textColor)
        .font(.caption)
    }
  }
  
  private var saveButton: some View {
    VStack(spacing: 5) {
      Button("save") {
        
        withAnimation { saveButtonPressed.toggle() }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
          if formVM.updating {
            formVM.updateToDo()
            presentationMode.wrappedValue.dismiss()
          } else {
            formVM.addToDo()
            presentationMode.wrappedValue.dismiss()
          }
        }
      }
      .disabled(formVM.isDisabled)
      
      Text("save")
        .foregroundColor(saveButtonPressed ? Constants.blue : Constants.textColor)
        .font(.caption)
    }
  }
}

// MARK: - Preview
struct TaskFormView_Previews: PreviewProvider {
  static var previews: some View {
    TaskForm(formVM: TaskFormViewModel())
  }
}
