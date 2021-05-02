//
//  ModalType.swift
//  Checked
//
//  Created by Larry N on 4/30/21.
//

import SwiftUI

enum ModalType: Identifiable, View {
  case newTask
  case update(Task)
  
  var id: String {
    switch self {
    case .newTask:
      return "new"
    case .update:
      return "update"
    }
  }
  
  var body: some View {
    switch self {
    case .newTask:
      return TaskForm(formVM: TaskFormViewModel())
    case .update(let task):
      return TaskForm(formVM: TaskFormViewModel(task))
    }
  }
}
