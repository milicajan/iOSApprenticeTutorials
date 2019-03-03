//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Milica Jankovic on 1/5/19.
//  Copyright © 2019 Milica Jankovic. All rights reserved.
//

import UIKit
import MessageUI

class DetailViewController: UIViewController {

  // MARK: Properties
  var downloadTask: URLSessionDownloadTask?
  var isPopUp = false
  var searchResult: SearchResult! {
    didSet {
      if isViewLoaded {
        updateUI()
      }
    }
  }
  
  enum AnimationStyle {
    case slide
    case fade
  }
  var dismissAnimationStyle = AnimationStyle.fade
  
  // MARK: Outlets
  @IBOutlet weak var popupView: UIView!
  @IBOutlet weak var artworkImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var kindLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var priceButton: UIButton!
  
  // MARK: Actions
  @IBAction func close() {
    dismissAnimationStyle = .slide
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func openInStore() {
    if let url = URL(string: searchResult.storeURL) {
      UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
  }
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
    popupView.layer.cornerRadius = 10
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
    gestureRecognizer.cancelsTouchesInView = false
    gestureRecognizer.delegate = self
    view.addGestureRecognizer(gestureRecognizer)
    if searchResult != nil {
      updateUI()
    }
    view.backgroundColor = UIColor.clear
    
    if isPopUp {
      let gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(close))
      gestureRecognizer.cancelsTouchesInView = false
      gestureRecognizer.delegate = self
      view.addGestureRecognizer(gestureRecognizer)
      view.backgroundColor = UIColor.clear
    } else {
      view.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
      popupView.isHidden = true
      if let displayName = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String {
        title = displayName
      }
    }
  }
  
  // MARK: Initializers
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    modalPresentationStyle = .custom
    transitioningDelegate = self
  }
  
  deinit {
    print("deinit \(self)")
    downloadTask?.cancel()
  }
  
  // MARK: UI methodes
  func updateUI() {
    nameLabel.text = searchResult.name
    
    if searchResult.artistName.isEmpty {
      artistNameLabel.text = NSLocalizedString("Unkown", comment: "Unkown artist name") 
    } else {
      artistNameLabel.text = searchResult.artistName
    }
    
    kindLabel.text = searchResult.kindForDisplay()
    genreLabel.text = searchResult.genre
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = searchResult.currency
    let priceText: String
    if searchResult.price == 0 {
      priceText = NSLocalizedString("Free", comment: "Price text is free") 
    } else if let text = formatter.string(
      from: searchResult.price as NSNumber) {
      priceText = text
    } else {
      priceText = ""
    }
    priceButton.setTitle(priceText, for: .normal)
    
    if let largeURL = URL(string: searchResult.artworkLargeURL) {
      downloadTask = artworkImageView.loadImage(url: largeURL)
    }
    popupView.isHidden = false
  }
  
  // MARK: Segue methode
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowMenu" {
      let controller = segue.destination as! MenuViewController
      controller.delegate = self
    }
  }
}

extension DetailViewController: UIViewControllerTransitioningDelegate {
  
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?,
                              source: UIViewController)  -> UIPresentationController? {
      return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
  }
  func animationController(forPresented presented: UIViewController,  presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      return BounceAnimationController()
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    switch dismissAnimationStyle {
    case .slide:
      return SlideOutAnimationController()
    case .fade:
      return  FadeOutAnimationController()
    }
  }
}

extension DetailViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return (touch.view === self.view)
  }
}

extension DetailViewController: MenuViewControllerDelegate {
  func menuViewControllerSendSupportEmail(_: MenuViewController) {
    dismiss(animated: true) {
      if MFMailComposeViewController.canSendMail() {
        let controller = MFMailComposeViewController()
        controller.setSubject(NSLocalizedString("Support Request",
                                                comment: "Email subject"))
        controller.setToRecipients(["your@email-address-here.com"])
        self.present(controller, animated: true, completion: nil)
        controller.mailComposeDelegate = self
        controller.modalPresentationStyle = .formSheet
      }
    }
  }
}

extension DetailViewController: MFMailComposeViewControllerDelegate {
  func mailComposeController(_ controller: MFMailComposeViewController,
                             didFinishWith result: MFMailComposeResult, error: Error?) {
    dismiss(animated: true, completion: nil)
  }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
