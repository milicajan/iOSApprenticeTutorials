//
//  AboutViewController.swift
//  BullsEye
//
//  Created by Milica Jankovic on 12/18/18.
//  Copyright © 2018 Milica Jankovic. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

  // MARK: Outlets
  
  @IBOutlet weak var webView: UIWebView!
  
  @IBAction func closeButton(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
 
  // MARK: View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let url = Bundle.main.url(forResource: "BullsEye", withExtension: "html") {
      if let htmlData = try? Data(contentsOf: url) {
        let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
        webView.load(htmlData, mimeType: "text/html", textEncodingName: "UTF-8", baseURL: baseURL)
      }
    }
  }

}
