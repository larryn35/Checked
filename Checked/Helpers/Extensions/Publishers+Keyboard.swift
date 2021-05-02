//
//  Publishers+Keyboard.swift
//  Checked
//
//  Created by Larry N on 5/1/21.
//

import SwiftUI
import Combine

// Modified from https://www.vadimbulavin.com/how-to-move-swiftui-view-when-keyboard-covers-text-field/

extension Publishers {
    static var keyboardDisplayed: AnyPublisher<Bool, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
          .map { _ in true }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in false }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardDisplayed: Bool {
      return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? Bool ?? false)
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
