//
//  AppDelegate.swift
//  Checklists
//
//  Created by Milica Jankovic on 12/19/18.
//  Copyright © 2018 Milica Jankovic. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

  var window: UIWindow?
  let dataModel = DataModel()
  
  func saveData() {
    dataModel.saveChecklists()
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let navigationController = window!.rootViewController as! UINavigationController
    let controller = navigationController.viewControllers[0] as! AllListsViewController
    controller.dataModel = dataModel
    
    let center = UNUserNotificationCenter.current()
//    center.requestAuthorization(options: [.alert, .sound]) {
//      granted, error in
//      if granted {
//        print("We have permission")
//      } else {
//        print("Permission denied")
//      }
//    }
     center.delegate = self
//    let content = UNMutableNotificationContent()
//    content.title = "Hello!"
//    content.body = "I am a local notification!"
//    content.sound = UNNotificationSound.default()
//
//    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
//    let request = UNNotificationRequest(identifier: "MyNotification", content: content, trigger: trigger)
//    center.add(request)
    return true
  }

  // MARK: UNUserNotificationCenter methodes
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    print("Recieve local notification \(notification)")
  }
  }




