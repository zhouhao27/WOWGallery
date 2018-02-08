//
//  MainViewController.swift
//  CollectionDemo
//
//  Created by Zhou Hao on 7/2/18.
//  Copyright © 2018 Zhou Hao. All rights reserved.
//

import UIKit
import WOWGallery

// There are two ways to use PhotoGridViewController
// 1. Inherit
// 2. Use it directly

class MainViewController: UITableViewController {

  var service = InternetImageRequester()
  var total: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    service.requestCount { (count) in
      self.total = count
    }
  }

  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowPhotoGridViewController" {
      if let vc = segue.destination as? PhotoGridViewController {
        vc.dataSource = self
        vc.delegate = self
        vc.placeHolderImage = UIImage(named:"PlaceHolder")
      }
    }
  }

}

extension MainViewController: PhotoGridViewControllerDelegate, PhotoGridViewControllerDataSource {
  
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
