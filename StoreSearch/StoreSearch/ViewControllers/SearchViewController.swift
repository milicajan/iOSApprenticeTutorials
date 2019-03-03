//
//  ViewController.swift
//  StoreSearch
//
//  Created by Milica Jankovic on 1/4/19.
//  Copyright © 2019 Milica Jankovic. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

  // MARK: Outlets
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  
  @IBAction func segmentChanged(_ sender: UISegmentedControl) {
    performSearch()
  }
  
  // MARK: Properties
  let search = Search()
  var landscapeViewController: LandscapeViewController?
  weak var splitViewDetail: DetailViewController?
  
  struct TableViewCellIdentifiers {
    static let searchResultCell = "SearchResultCell"
    static let nothingFoundCell = "NothingFoundCell"
    static let loadingCell = "LoadingCell"
    
  }
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.becomeFirstResponder()
    tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
    var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
    cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
    cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
    tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
    tableView.rowHeight = 80
    title = NSLocalizedString("Search", comment: "Split-view master button")
    if UIDevice.current.userInterfaceIdiom != .pad {
      searchBar.becomeFirstResponder()
    }
  }
  
  override func willTransition(to newCollection: UITraitCollection,
                               with coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransition(to: newCollection, with: coordinator)
    let rect = UIScreen.main.bounds
    if (rect.width == 736 && rect.height == 414) || // portrait
      (rect.width == 414 && rect.height == 736) { // landscape
      if presentedViewController != nil {
        dismiss(animated: true, completion: nil)
      }
    } else if UIDevice.current.userInterfaceIdiom != .pad {
      switch newCollection.verticalSizeClass {
      case .compact:
        showLandscape(with: coordinator)
      case .regular, .unspecified:
        hideLandscape(with: coordinator)
      }
    }
  }
    
    
  // MARK: UIAlert methode
  func showNetworkError() {
    let alert = UIAlertController(title: NSLocalizedString("Whoops...", comment: "Error alert: title"),
                                  message: NSLocalizedString("There was an error reading from the iTunes Store. Please try again.",
                                                             comment: "Error alert: message"),
                                  preferredStyle: .alert)
    let action = UIAlertAction(title: NSLocalizedString(
      "OK", comment: "Error action: title"),
                               style: .default, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    performSearch()
  }
  
  // MARK: Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowDetail" {
      if case .results(let list) = search.state {
        let detailViewController = segue.destination as! DetailViewController
        let indexPath = sender as! IndexPath
        let searchResult = list[indexPath.row]
        detailViewController.searchResult = searchResult
        detailViewController.isPopUp = true
      }
    }
 }
 
  // MARK: LandscapreViewController methode
  func showLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
    guard landscapeViewController == nil else {return}
    
    landscapeViewController = storyboard!.instantiateViewController(withIdentifier: "LandscapeViewController") as? LandscapeViewController
    if let controller = landscapeViewController {
      controller.search = search
      controller.view.frame = view.bounds
      view.addSubview(controller.view)
      addChild(controller)
      
      coordinator.animate(alongsideTransition: { _ in
        controller.view.alpha = 1
        self.searchBar.resignFirstResponder()
        if self.presentedViewController != nil {
          self.dismiss(animated: true, completion: nil)
        }
      }, completion: {_ in
         controller.didMove(toParent: self)
      })
    }
  }
  
  func hideLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
    if let controller = landscapeViewController {
      controller.willMove(toParent: nil)
      
      coordinator.animate(alongsideTransition: {_ in
         controller.view.alpha = 0
        if self.presentedViewController != nil {
          self.dismiss(animated: true, completion: nil)
        }
      }, completion: { _ in
        controller.view.removeFromSuperview()
        controller.removeFromParent()
        self.landscapeViewController = nil
      })
    }
  }
  
  func hideMasterPane() {
    UIView.animate(withDuration: 0.25, animations: {
      self.splitViewController!.preferredDisplayMode = .primaryHidden
    }, completion: { _ in
      self.splitViewController!.preferredDisplayMode = .automatic
    })
  }
}


// MARK: UISearchBarDelegate methode
extension SearchViewController: UISearchBarDelegate {
  
  func performSearch() {
    if let category = Search.Category(rawValue: segmentedControl.selectedSegmentIndex) {
    search.performSearch(for: searchBar.text!, category: category, completion: { success in
      if !success {
        self.showNetworkError()
      }
      self.tableView.reloadData()
      self.landscapeViewController?.searchResultRecieved()
    })
    tableView.reloadData()
    searchBar.resignFirstResponder()
  }
  }
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

// MARK: UITableViewDataSource methode
extension SearchViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    switch search.state {
    case .loading: return 1
    case .notSearchedYet: return 0
    case .noResults: return 1
    case .results(let list):  return list.count
      
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch search.state {
    case .notSearchedYet:
      fatalError("Should never get here")
      
    case .loading:
      let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.loadingCell, for: indexPath)
      let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell
      
    case .noResults:
      return tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.nothingFoundCell, for: indexPath)
      
    case .results(let list):
      let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
      let searchResult = list[indexPath.row]
      cell.configure(for: searchResult)
      return cell
    }
  }
}

extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    searchBar.resignFirstResponder()
    
    if view.window!.rootViewController!.traitCollection.horizontalSizeClass == .compact {
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: "ShowDetail", sender: indexPath)
    } else {
      if splitViewController!.displayMode != .allVisible {
        hideMasterPane()
      }
      if case .results(let list) = search.state {
        splitViewDetail?.searchResult = list[indexPath.row]
      }
    }  
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    switch search.state {
    case .notSearchedYet, .loading, .noResults:
      return nil
    case .results:
      return indexPath
    }
  }
}
