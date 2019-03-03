//
//  MenuViewController.swift
//  StoreSearch
//
//  Created by Milica Jankovic on 1/8/19.
//  Copyright © 2019 Milica Jankovic. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
  // MARK: Propertie
  weak var delegate: MenuViewControllerDelegate?

  // MARK: UITableViewDelegate methode
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if indexPath.row == 0 {
      delegate?.menuViewControllerSendSupportEmail(self)
    }
  }
}

protocol MenuViewControllerDelegate: class {
  func menuViewControllerSendSupportEmail(_ controller: MenuViewController)
}
