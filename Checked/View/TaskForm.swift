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

  // For button animations
  @State private var cancelButtonPressed: Bool = false
  @State private var saveButtonPressed: Bool = false
  
  @State private var showDeadlinePicker: Bool = false
  
  @State private var keyBoardDisplayed: Bool = false
    
  private let hapticsManager = HapticsManager()
  
  var body: some View {
    ViewLayout(backgroundImage: formVM.backgroundImage) {
      
      // MARK: - Header
      
      // Hide when keyboard is displayed to create roomr for TextEditor (blocked on smaller devices)
      if !keyBoardDisplayed {
        Text(formVM.formTitle)
          .customFont(style: .largeTitle, weight: .semibold, textColor: .white)
          .transition(.move(edge: .top))
      }
        
      // MARK: - Body
    } content: {
      
      ScrollView {
      
      VStack(alignment: .leading, spacing: 20) {
        
          // MARK: Priority status buttons
          HStack {
            ForEach(PriorityType.allCases) { priority in
              Button {
                hapticsManager.impact(style: .soft)
                formVM.priority = priority
              } label: {
                // priority.rawValue : Int; 0 = low, 1 = medium, 2 = high
                Text(priority.text)
                  .customFont(style: .caption1,
                              textColor: Constants.prioritiyColors[priority.rawValue])
                  .padding(.vertical, 8)
                  .frame(width: 70)
                  .background(
                    RoundedRectangle(cornerRadius: 10)
                      .fill(Constants.priorityBGColors[priority.rawValue])
                      .overlay(RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Constants.prioritiyColors[priority.rawValue], lineWidth: 0.5))
                  )
                  .opacity(formVM.priority == priority ? 1 : 0.3)
              }
            }
          }
          .padding(.top)
          
        // MARK: Date created
        
        if formVM.updating {
          VStack(alignment: .leading) {
            Text("Date created")
              .customFont(style: .subheadline, weight: .semibold)
            Text(formVM.dateCreated)
              .customFont()
          }
        }
          
        // MARK: Edit task title
        VStack(alignment: .leading) {
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
        
        // MARK: Edit task note
        VStack(alignment:.leading) {
          HStack {
            Text("Notes")
              .customFont(style: .subheadline, weight: .semibold)
            
            // Dismiss keyboard button
            if keyBoardDisplayed {
              Button {
                hideKeyboard()
              } label: {
                Label("Dismiss keyboard", systemImage: "keyboard.chevron.compact.down")
                  .customFont(style: .caption1, textColor: Constants.blue)
                  .frame(maxWidth: .infinity, alignment: .trailing)
              }
            }
          }
          // Detect when keyboard is displayed/hidden
          .onReceive(Publishers.keyboardDisplayed) { (status) in
            withAnimation { keyBoardDisplayed = status }
          }
          
          TextEditor(text: $formVM.notes)
            .modifier(CustomTextFieldModifier())
            .frame(height: 100)
        }
        
        // MARK: Date Pickers
        if !formVM.taskCompleted {
          // Set deadline
          DatePickerView(showDatePicker: $formVM.showDeadlinePicker,
                         text: formVM.deadlineText,
                         date: $formVM.deadline)
          
          // Set reminder
          DatePickerView(showDatePicker: $formVM.showReminderPicker,
                         text: formVM.reminderText,
                         date: $formVM.reminderDate)
          
          // MARK: Date completed text
        } else {
          // Task completed
          Text("Date completed: \(formVM.dateCompletedText)")
            .customFont(style: .subheadline, weight: .semibold)
            .padding(.bottom)
        }
        
        Spacer()
        
        // MARK: Error message
        if formVM.showErrorMessage {
          Text(formVM.formError!.rawValue)
            .customFont(style: .subheadline,
                        weight: .semibold,
                        textColor: Constants.magenta)
            .padding(.bottom)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        
        // MARK: Cancel/save buttons
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
        
        // Check if form is valid
        formVM.validateForm()
        
        // Form is not valid
        if formVM.formError != nil {
          hapticsManager.notification(type: .error)
          
          // Form is valid
        } else {
          hapticsManager.notification(type: .success)
          withAnimation { saveButtonPressed.toggle() }
          
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            if formVM.updating {
              formVM.updateTask()
            } else {
              formVM.addTask()
            }
            presentationMode.wrappedValue.dismiss()
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
