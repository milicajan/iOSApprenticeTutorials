//
//  AppDelegate.swift
//  StoreSearch
//
//  Created by Milica Jankovic on 1/4/19.
//  Copyright © 2019 Milica Jankovic. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func customizeAppearance() {
    let barTintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
    UISearchBar.appearance().barTintColor = barTintColor
    window!.tintColor = UIColor(red: 10/255, green: 80/255, blue: 80/255, alpha: 1)
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    customizeAppearance()
    detailNavigationController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
    searchViewController.splitViewDetail = detailViewController
    splitViewController.delegate = self
    return true
  }
  
  var splitViewController: UISplitViewController {
    return window!.rootViewController as! UISplitViewController
  }
  var searchViewController: SearchViewController {
    return splitViewController.viewControllers.first as! SearchViewController
  }
  var detailNavigationController: UINavigationController {
    return splitViewController.viewControllers.last as! UINavigationController
  }
  var detailViewController: DetailViewController {
    return detailNavigationController.topViewController as! DetailViewController
  }
}

extension AppDelegate: UISplitViewControllerDelegate {
  func splitViewController(_ svc: UISplitViewController,willChangeTo displayMode: UISplitViewController.DisplayMode) {
    print(#function)
    if displayMode == .primaryOverlay {
      svc.dismiss(animated: true, completion: nil)
    }
  }
}
