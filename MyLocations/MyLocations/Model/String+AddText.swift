//
//  String+AddText.swift
//  MyLocations
//
//  Created by Milica Jankovic on 12/28/18.
//  Copyright © 2018 Milica Jankovic. All rights reserved.
//

import Foundation

extension String {
  mutating func add(text: String?, separatedBy separator: String = "") {
    if let text = text {
      if !isEmpty {
        self += separator
      }
      self += text
    }
  }
}
