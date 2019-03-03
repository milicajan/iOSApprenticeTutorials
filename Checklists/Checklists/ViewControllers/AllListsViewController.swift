//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Milica Jankovic on 12/20/18.
//  Copyright © 2018 Milica Jankovic. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
  
  //MARK: Properties
  var dataModel: DataModel!
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    print("Documents folder is \(dataModel.documentsDirectory())")
//    print("Data file path is \(dataModel.dataFilePath())")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    
    navigationController?.delegate = self
    let index = dataModel.indexOfSelectedChecklist
    if index >= 0 && index < dataModel.lists.count {
      let checklist = dataModel.lists[index]
      performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
  }
    // MARK: - TableView DataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = makeCell(for: tableView)
      
      let checklist =  dataModel.lists[indexPath.row]
      cell.textLabel!.text = checklist.name
      cell.accessoryType = .detailDisclosureButton
      
      let count = checklist.countUncheckedItems()
      if checklist.items.count == 0 {
        cell.detailTextLabel!.text = "No items"
      } else if count == 0 {
        cell.detailTextLabel!.text = "All done!"
      } else {
      cell.detailTextLabel!.text = "\(checklist.countUncheckedItems()) Remaining"
      }
      cell.imageView!.image = UIImage(named: checklist.iconName)
      return cell
    }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   dataModel.indexOfSelectedChecklist = indexPath.row
    
    let checklist =  dataModel.lists[indexPath.row]
    performSegue(withIdentifier: "ShowChecklist", sender: checklist)
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    dataModel.lists.remove(at: indexPath.row)
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: UITableView.RowAnimation.automatic)
  }
  
  override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController")
      as! UINavigationController
    let controller = navigationController.topViewController
      as! ListDetailViewController
    controller.delegate = self
    let checklist =  dataModel.lists[indexPath.row]
    controller.checklistToEdit = checklist
    present(navigationController, animated: true, completion: nil)
  }
  
  // MARK: Cell Methode
  func makeCell(for tableView: UITableView) -> UITableViewCell {
    let cellIdentifier = "Cell"
    
    if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
      return cell
    } else {
      return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
    }
  }
  
  // MARK: Segue
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowChecklist" {
      let controller = segue.destination as! ChecklistViewController
      controller.checklist = (sender as! Checklist)
    } else if segue.identifier == "AddChecklist" {
      let navigationController = segue.destination  as! UINavigationController
      let controller = navigationController.topViewController as! ListDetailViewController
      controller.delegate = self
      controller.checklistToEdit = nil
    }
  }
  
  // MARK: ListDetailViewcControllerDelegate methodes
  
  func listDetailViewControllerDidCancel( _ controller: ListDetailViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
    dataModel.lists.append(checklist)
    dataModel.sortChecklists()
    tableView.reloadData()
    dismiss(animated: true, completion: nil)
  }
  
  func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
    dataModel.sortChecklists()
    tableView.reloadData()
    dismiss(animated: true, completion: nil)
  }

  // UINavigationControllerDelegate methodes
  
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    if viewController === self {
      dataModel.indexOfSelectedChecklist = -1
    }
  }
}
