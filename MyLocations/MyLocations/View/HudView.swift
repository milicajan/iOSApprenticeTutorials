//
//  HudView.swift
//  MyLocations
//
//  Created by Milica Jankovic on 12/25/18.
//  Copyright © 2018 Milica Jankovic. All rights reserved.
//

import UIKit

class HudView: UIView {
  var text = ""
  
  class func hud(inView view: UIView, animated: Bool) -> HudView {
    let hudView = HudView(frame: view.bounds)
    hudView.isOpaque = false
    
    view.addSubview(hudView)
    view.isUserInteractionEnabled = false
    
    hudView.show(animated: animated)
    return hudView
  }

  override func draw(_ rect: CGRect) {
    let boxWidth: CGFloat = 96
    let boxHeight: CGFloat = 96
    
    let boxRect = CGRect(
      x: round((bounds.size.width - boxWidth) / 2),
      y: round((bounds.size.height - boxHeight) / 2),
      width: boxWidth,
      height: boxHeight)
    
    let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
    UIColor(white: 0.3, alpha: 0.8).setFill()
    roundedRect.fill()
    
    if let image = UIImage(named: "Checkmark") {
      let imagePoint = CGPoint(
        x: center.x - round(image.size.width / 2),
        y: center.y - round(image.size.height / 2) - boxHeight / 8)
      
      image.draw(at: imagePoint)
    }
    
    let attribs = [ convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 16),
                    convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.white ]
    
    let textSize = text.size(withAttributes: convertToOptionalNSAttributedStringKeyDictionary(attribs))
    
    let textPoint = CGPoint(
      x: center.x - round(textSize.width / 2),
      y: center.y - round(textSize.height / 2) + boxHeight / 4)
    
    text.draw(at: textPoint, withAttributes: convertToOptionalNSAttributedStringKeyDictionary(attribs))
  }
  
  func show(animated: Bool) {
    if animated {
      alpha = 0
      transform = CGAffineTransform(scaleX: 1.3, y: 1.3)

      UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
          self.alpha = 1
          self.transform = CGAffineTransform.identity
        },
        completion: nil)
    }
  }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
