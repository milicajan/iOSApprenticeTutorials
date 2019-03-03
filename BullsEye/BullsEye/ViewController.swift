//
//  ViewController.swift
//  BullsEye
//
//  Created by Milica Jankovic on 12/17/18.
//  Copyright © 2018 Milica Jankovic. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

  // MARK: Properties
  var currentValue: Int = 0
  var targetValue: Int = 0
  var score: Int = 0
  var round: Int = 0
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    startNewGame()
    updateLabels()
    
    let thumbImageNormal = #imageLiteral(resourceName: "SliderThumb-Normal")
    slider.setThumbImage(thumbImageNormal, for: .normal)
    let thumbImageHighlighted = #imageLiteral(resourceName: "SliderThumb-Highlighted")
    slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
    let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    let trackLeftImage = #imageLiteral(resourceName: "SliderTrackLeft")
    let trackLeftResizable =
      trackLeftImage.resizableImage(withCapInsets: insets)
    slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
    let trackRightImage = #imageLiteral(resourceName: "SliderTrackRight")
    let trackRightResizable =
      trackRightImage.resizableImage(withCapInsets: insets)
    slider.setMaximumTrackImage(trackRightResizable, for: .normal)
  }


  // MARK: Outlets
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var roundLabel: UILabel!
  
  // MARK: Actions
  @IBAction func showAlert() {
    
    let  difference = abs(currentValue - targetValue)
    var points = 100 - difference
    
    let title: String
    if difference == 0 {
      title = "Perfect"
      points += 100
    } else if difference < 5 {
      title = "You almost had it!"
      if difference == 1 {
        points += 50
      }
    } else if difference < 10 {
      title = "Pretty good!"
    } else {
      title = "Not even close..."
    }
    score += points
    let message = "You scored \(points) points "
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: {action in
      self.startNewRound()
      self.updateLabels()
    })
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func sliderMoved(_ sender: UISlider) {
   currentValue = lroundf(sender.value)
  }
  
  @IBAction func startOver(_ sender: UIButton) {
    startNewGame()
    updateLabels()
    
    let transition = CATransition()
    transition.type = convertToCATransitionType(kCATransition)
    transition.duration = 1
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    view.layer.add(transition, forKey: nil)
  }
  
  // MARK: Methodes
  func startNewRound() {
    round += 1
    targetValue = 1 + Int(arc4random_uniform(100))
    currentValue = 50
    slider.value = Float(currentValue)
  }
  
  func startNewGame() {
    score = 0
    round = 0
    startNewRound()
  }
  
  func updateLabels() {
    targetLabel.text = String(targetValue)
    scoreLabel.text = String(score)
    roundLabel.text = String(round)
  }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCATransitionType(_ input: String) -> CATransitionType {
	return CATransitionType(rawValue: input)
}
