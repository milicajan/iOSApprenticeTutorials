//
//  CategoryPickerViewController.swift
//  MyLocations
//
//  Created by Milica Jankovic on 12/25/18.
//  Copyright © 2018 Milica Jankovic. All rights reserved.
//

import UIKit

class CategoryPickerViewController: UITableViewController {
  // MARK: Properties
  
  var selectedCategoryName = ""
  let categories = [
    "No Category",
    "Apple Store",
    "Bar",
    "Bookstore",
    "Club",
    "Grocery Store",
    "Historic Building",
    "House",
    "Icecream Vendor",
    "Landmark",
    "Park"]
  
  var selectedIndexPath = IndexPath()
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    for i in 0..<categories.count {
      if categories[i] == selectedCategoryName {
        selectedIndexPath = IndexPath(row: i, section: 0)
        break
      }
    }
    
    tableView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    tableView.separatorColor = UIColor(white: 1.0, alpha: 0.2)
    tableView.indicatorStyle = .white
  }
  
  // MARK: Segue methode
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PickedCategory" {
      let cell = sender as! UITableViewCell
      if let indexPath = tableView.indexPath(for: cell) {
        selectedCategoryName = categories[indexPath.row]
      }
    }
  }
  
  // MARK: - UITableViewDataSource
  
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "Cell", for: indexPath)
    
    let categoryName = categories[indexPath.row]
    cell.textLabel!.text = categoryName
    
    if categoryName == selectedCategoryName {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }
    return cell
  }
  
  // MARK: - UITableViewDelegate
  
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    if indexPath.row != selectedIndexPath.row {
      if let newCell = tableView.cellForRow(at: indexPath) {
        newCell.accessoryType = .checkmark
      }
      
      if let oldCell = tableView.cellForRow(at: selectedIndexPath) {
        oldCell.accessoryType = .none
      }
      
      selectedIndexPath = indexPath
    }
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.backgroundColor = .black
    if let textLabel = cell.textLabel {
      textLabel.textColor = .white
      textLabel.highlightedTextColor = textLabel.textColor
    }
    
    let selectionView = UIView(frame: CGRect.zero)
    selectionView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
    cell.selectedBackgroundView = selectionView 
  }
}
