//
//  MyTabBarController.swift
//  MyLocations
//
//  Created by Milica Jankovic on 12/29/18.
//  Copyright © 2018 Milica Jankovic. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  override var childForStatusBarStyle: UIViewController? {
    return nil
  }
}
