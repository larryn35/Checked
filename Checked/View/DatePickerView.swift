//
//  DatePickerView.swift
//  Checked
//
//  Created by Larry N on 5/1/21.
//

import SwiftUI

struct DatePickerView: View {
  var showDatePicker: Binding<Bool>
  var text: String
  var date: Binding<Date>
  
  var body: some View {
    HStack(alignment: .top) {
      VStack(alignment: .leading) {
        Text(text)
          .font(.subheadline)
          .fontWeight(.semibold)
        
        if showDatePicker.wrappedValue {
          DatePicker("Select date", selection: date, in: Date()...)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accentColor(Constants.blue)
            .labelsHidden()
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      
      
      Button("Set Deadline") {        
        withAnimation {
          showDatePicker.wrappedValue.toggle()
        }
      }
    }
  }
}

struct DatePickerView_Previews: PreviewProvider {
  static var previews: some View {
    DatePickerView(showDatePicker: .constant(true), text: "Set deadline", date: .constant(Date()))
  }
}
