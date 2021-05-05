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
  
  let hapticsManager = HapticsManager()
  
  var body: some View {
    ViewLayout(backgroundImage: formVM.backgroundImage) {
      
      // MARK: - Header
      Text(formVM.formTitle)
        .customFont(style: .largeTitle, weight: .semibold, textColor: .white)
        .opacity(keyBoardDisplayed ? 0.1 : 1)
      
      // MARK: - Body
    } content: {
      VStack(alignment: .leading, spacing: 20) {
        
        // Priority status buttons
        HStack {
          ForEach(PriorityType.allCases) { status in
            Button {
              hapticsManager.impact(style: .soft)

              formVM.priority = status
            } label: {
              Text(status.text)
                .customFont(style: .caption1,
                            textColor: Constants.prioritiyColors[status.rawValue])
                .padding(.vertical, 8)
                .frame(width: 70)
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
          .customFont(style: .subheadline, weight: .semibold)
        
        // Edit task title
        VStack(alignment:.leading) {
          Text("Task")
            .customFont(style: .subheadline, weight: .semibold)
          
          HStack {
            TextField(formVM.placeholderText, text: $formVM.title)
            Button {
              formVM.title = ""
            } label: {
              Image(systemName: "xmark.circle")
                .foregroundColor(.secondary)
            }
          }
          .modifier(CustomTextFieldModifier())
        }
        
        // Edit task note
        VStack(alignment:.leading) {
          HStack {
            Text("Description")
              .customFont(style: .subheadline, weight: .semibold)
            
            // Dismiss keyboard button
            if keyBoardDisplayed {
              Button {
                hideKeyboard()
              } label: {
                Label("Dismiss keyboard", systemImage: "keyboard.chevron.compact.down")
                  .customFont(style: .caption1, textColor: Constants.orange)
                  .frame(maxWidth: .infinity, alignment: .trailing)
              }
            }
          }
          .onReceive(Publishers.keyboardDisplayed) { (status) in
            keyBoardDisplayed = status
          }
          
          TextEditor(text: $formVM.notes)
            .modifier(CustomTextFieldModifier())
            .frame(minHeight: 20, maxHeight: 120)
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
            .customFont(style: .subheadline, weight: .semibold)
            .padding(.bottom)
        }
        
        Spacer()
        
        if formVM.showErrorMessage {
          Text(formVM.formError!.rawValue)
            .customFont(style: .subheadline,
                        weight: .semibold,
                        textColor: Constants.magenta)
            .padding(.bottom)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        
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
        hapticsManager.impact(style: .light)

        withAnimation { cancelButtonPressed.toggle() }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
          presentationMode.wrappedValue.dismiss()
        }
      }
      .buttonStyle(RotateAnimationStyle(bindingBool: $cancelButtonPressed,
                                        sfSymbol: .xmark))
      
      Text("cancel")
        .customFont(style: .caption1)
    }
  }
  
  private var saveButton: some View {
    VStack(spacing: 5) {
      Button("save") {
        
        formVM.validateForm()
        
        if formVM.formError != nil {
          hapticsManager.notification(type: .error)
          
        } else {
        
          hapticsManager.notification(type: .success)
          
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
      }
      .buttonStyle(CircleFillAnimationStyle(bindingBool: $saveButtonPressed,
                                            sfSymbol: .folder))
      
      Text("save")
        .customFont(style: .caption1,
                    textColor: saveButtonPressed ? Constants.blue : Constants.textColor)
    }
  }
}

// MARK: - Preview
struct TaskFormView_Previews: PreviewProvider {
  static var previews: some View {
    TaskForm(formVM: TaskFormViewModel())
  }
}
