//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Milica Jankovic on 1/4/19.
//  Copyright © 2019 Milica Jankovic. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

  // MARK: Outlets
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var artworkImageView: UIImageView!

  // MARK: Properties
  var downloadTask: URLSessionDownloadTask?
  
  // MARK: Cell methodes
  override func awakeFromNib() {
    super.awakeFromNib()
    let selectedView = UIView(frame: CGRect.zero)
    selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
    selectedBackgroundView = selectedView
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    downloadTask?.cancel()
    downloadTask = nil
  }
  
  func configure(for searchResult: SearchResult) {
    nameLabel.text = searchResult.name
    if searchResult.artistName.isEmpty {
      artistNameLabel.text = NSLocalizedString("Unkown", comment: "Unkown artist name") 
    } else {
      artistNameLabel.text = String(format: NSLocalizedString("ARTIST_NAME_LABEL_FORMAT", comment: "Format for artist name label"), searchResult.artistName, searchResult.kindForDisplay())
    }
    artworkImageView.image = UIImage(named: "Placeholder")
    if let smallURL = URL(string: searchResult.artworkSmallURL) {
      downloadTask = artworkImageView.loadImage(url: smallURL)
    }
  }

}
