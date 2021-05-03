//
//  NotificationManager.swift
//  Checked
//
//  Created by Larry N on 5/2/21.
//

import UIKit

struct NotificationManager {
  
  // Request user for permission when initializing
  init() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      if granted == true && error == nil {
        print("Notifications permitted")
      } else {
        print("Notifications not permitted")
      }
    }
  }
  
  func sendNotification(id: String, body: String, triggerDate: Date) {
    let content = UNMutableNotificationContent()
    content.title = "Task Reminder"
    content.body = body
    content.badge = 1
    content.sound = .default
    
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.day,.month,.year,.hour,.minute], from: triggerDate)
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
        print("Error setting notification: \(error)")
      } else {
        print("Notification set")
      }
    }
  }
  
  func removeNotification(id: String) {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
  }
  
  func removeBadge() {
    UIApplication.shared.applicationIconBadgeNumber = 0
  }
}
