//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Milica Jankovic on 12/19/18.
//  Copyright © 2018 Milica Jankovic. All rights reserved.
//

import Foundation
import  UserNotifications

class ChecklistItem: NSObject, NSCoding {
  
  // MARK: Variables
  var text = ""
  var checked = false
  var dueDate = Date()
  var shouldRemind = false
  var itemID: Int
  
  func toggleChecked() {
    checked = !checked
  }
  
  // MARK: Init methodes
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(text, forKey: "Text")
    aCoder.encode(checked, forKey: "Checked")
    aCoder.encode(dueDate, forKey: "DueDate")
    aCoder.encode(shouldRemind, forKey: "ShouldRemind")
    aCoder.encode(itemID, forKey: "ItemID")
  }
  
  required init?(coder aDecoder: NSCoder) {
    text = aDecoder.decodeObject(forKey: "Text") as! String
    checked = aDecoder.decodeBool(forKey: "Checked")
    dueDate = aDecoder.decodeObject(forKey: "DueDate") as! Date
    shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
    itemID = aDecoder.decodeInteger(forKey: "ItemID")
    super.init()
  }
  
  override init() {
    itemID = DataModel.nextChecklistItemID()
    super.init()
  }
  deinit {
    removeNotification()
  }
  
  func sheduleNotification() {
    removeNotification()
    if shouldRemind && dueDate > Date() {
      let content = UNMutableNotificationContent()
      content.title = "Reminder:"
      content.body = text
      content.sound = UNNotificationSound.default
  
      let calendar = Calendar(identifier: .gregorian)
      let components = calendar.dateComponents(
        [.month, .day, .hour, .minute], from: dueDate)
   
      let trigger = UNCalendarNotificationTrigger(
        dateMatching: components, repeats: false)
    
      let request = UNNotificationRequest(
        identifier: "\(itemID)", content: content, trigger: trigger)
    
      let center = UNUserNotificationCenter.current()
      center.add(request)
      print("Scheduled notification \(request) for itemID \(itemID)")
    }
  }
  
  func removeNotification() {
    let center = UNUserNotificationCenter.current()
    center.removeDeliveredNotifications(withIdentifiers: ["\(itemID)"])
  }
}
