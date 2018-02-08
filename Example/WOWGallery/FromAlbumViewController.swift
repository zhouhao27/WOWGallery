//
//  FromAlbumViewController.swift
//  CollectionDemo
//
//  Created by Zhou Hao on 7/2/18.
//  Copyright © 2018 Zhou Hao. All rights reserved.
//

import UIKit
import WOWGallery

class FromAlbumViewController: PhotoGridViewController {

  @IBOutlet weak var btnSelect: UIBarButtonItem!
  let service = PhotoAlbumRequester()
  var total = 0  

  override var isSelectMode: Bool {
    didSet {
      btnSelect.title = isSelectMode ? "Cancel" : "Select"
      if !isSelectMode {
        title = "Photo Gallery"
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    service.requestCount { (count) in
      self.total = count
      self.reloadData()
    }
    self.delegate = self
    self.dataSource = self
    self.placeHolderImage = UIImage(named: "PlaceHolder")
  }
  
  @IBAction func onSelect(_ sender: Any) {
    isSelectMode = !isSelectMode
  }
  
}

extension FromAlbumViewController: PhotoGridViewControllerDelegate, PhotoGridViewControllerDataSource {
  
  func numberOfPhotos(in photoGridViewController: PhotoGridViewController) -> Int {
    return total
  }
  
  func thumbnail(in photoGridViewController: PhotoGridViewController, at index: Int, complete: @escaping (UIImage?) -> Void) {
    
    self.service.requestThumbnail(index: index, complete: complete)
  }
  
  func photo(in photoGridViewController: PhotoGridViewController, at index: Int, complete: @escaping (UIImage?) -> Void) {
    self.service.requestImage(index: index, complete: complete)
  }
  
  // delegate
  func photoGridViewController(_ photoGridViewController: PhotoGridViewController, selectedNumberOfCells: Int) {
    title = selectedNumberOfCells > 0 ? "\(selectedNumberOfCells) selected" : "Photo Gallery"
  }
}
