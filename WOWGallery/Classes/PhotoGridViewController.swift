//
//  PhotoGridViewController.swift
//  CollectionDemo
//
//  Created by Zhou Hao on 7/2/18.
//  Copyright © 2018 Zhou Hao. All rights reserved.
//

import UIKit

// TODO:
// 1. Custom Transition doesn't work well
// 2. CocoaPods and Carthage
// 3. Add test

public protocol PhotoGridViewControllerDataSource: class {
  func numberOfPhotos(in photoGridViewController: PhotoGridViewController) -> Int
  func thumbnail(in photoGridViewController: PhotoGridViewController, at index: Int, complete: @escaping (UIImage?) -> Void)
  func photo(in photoGridViewController: PhotoGridViewController, at index: Int, complete: @escaping (UIImage?) -> Void)
}

public protocol PhotoGridViewControllerDelegate: class {
  func photoGridViewController(_ photoGridViewController: PhotoGridViewController, selectedNumberOfCells: Int)
}

open class PhotoGridViewController: UIViewController {

  // MARK: - public properties
  open weak var dataSource: PhotoGridViewControllerDataSource?
  open weak var delegate: PhotoGridViewControllerDelegate?
  open var placeHolderImage: UIImage?
  
  // MARK: - internal properties
  var collectionView: UICollectionView!
  var photoCount: Int = 0 // total count
  var thumbnailCache = NSCache<NSString, UIImage>()
  var photoCache = NSCache<NSString, UIImage>()
  var index: Int = 0
  open var isSelectMode: Bool = false {
    didSet {
      if oldValue == true { // unselect
        selected.removeAll()
        collectionView.reloadData()
      }
    }
  }
  
  var selected: Set<Int> = []

  // MARK: - View life cycle
  override open func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
  }
  
  override open func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    collectionView.collectionViewLayout.invalidateLayout()
  }
  
  // MARK: - private methods
  func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    
    collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(PhotoItemCell.self, forCellWithReuseIdentifier: String(describing: PhotoItemCell.self))
    collectionView.backgroundColor = UIColor.white
    
    if #available(iOS 10, *) {
      collectionView.prefetchDataSource = self
    }
    
    self.view.addSubview(collectionView)
    
    // TODO: using autoLayout
    collectionView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
  }
  
  // MARK: - Public methods
  open func reloadData() {
    self.collectionView.reloadData()
  }

}

extension PhotoGridViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
  fileprivate func isLandscape() -> Bool {
    return UIDevice.current.orientation.isValidInterfaceOrientation
      ? UIDevice.current.orientation.isLandscape
      : UIApplication.shared.statusBarOrientation.isLandscape
  }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    collectionView.deselectItem(at: indexPath, animated: true)
    if isSelectMode {
      if selected.contains(indexPath.row) {
        selected.remove(indexPath.row)
      } else {
        selected.insert(indexPath.row)
      }
      self.delegate?.photoGridViewController(self, selectedNumberOfCells: selected.count)
      collectionView.reloadItems(at: [indexPath])
    } else {

      let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)
      gallery.backgroundColor = UIColor.black
      gallery.pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
      gallery.currentPageIndicatorTintColor = UIColor(red: 0.0, green: 0.66, blue: 0.875, alpha: 1.0)
      gallery.hidePageControl = false
      
      present(gallery, animated: true, completion: { () -> Void in
        gallery.currentPage = indexPath.row
      })

    }
  }
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //return photoCount
    return self.dataSource?.numberOfPhotos(in: self) ?? 0
  }
  
  @available(iOS 10.0, *)
  public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    
    for indexPath in indexPaths{
      let imageKey = "\(indexPath.row)" as NSString
      if thumbnailCache.object(forKey: imageKey) == nil {
      
        self.dataSource?.thumbnail(in: self, at: indexPath.row, complete: { (image) in
          if let image = image {
            self.thumbnailCache.setObject(image, forKey: imageKey)
            self.collectionView.reloadItems(at: [indexPath])
          }
        })
      }
    }
  }

  @available(iOS 10.0, *)
  public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoItemCell.self) , for: indexPath) as! PhotoItemCell
    
    cell.isSelected = selected.contains(indexPath.row)
    
    let imageKey = "\(indexPath.row)" as NSString
    if let image = thumbnailCache.object(forKey: imageKey) {
      cell.imageView.image = image
    } else {
      cell.imageView.image = placeHolderImage
      
      self.dataSource?.thumbnail(in: self, at: indexPath.row, complete: { (image) in
        if let image = image {
          self.thumbnailCache.setObject(image, forKey: imageKey)
          DispatchQueue.main.async {
            cell.imageView.image = image
          }
        }        
      })
    }
    return cell
  }
  
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1.0
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1.0
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width
    
    return isLandscape() ? CGSize(width: width/6 - 1, height: width/6 - 1) : CGSize(width: width/4 - 1, height: width/4 - 1)
  }
}

extension PhotoGridViewController: SwiftPhotoGalleryDelegate, SwiftPhotoGalleryDataSource {
  
  public func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
    return self.dataSource?.numberOfPhotos(in: self) ?? 0
  }
  
  public func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {
    return placeHolderImage
  }
  
  public func loadImage(forGallery gallery: SwiftPhotoGallery, at index: Int, complete: @escaping (UIImage?) -> ()) {
    
    // load from cache
    let imageKey = "\(index)" as NSString
    if let image = photoCache.object(forKey: imageKey) {
      complete(image)
    } else {
      
      self.dataSource?.photo(in: self, at: index, complete: { (image) in
        if let image = image {
          self.photoCache.setObject(image, forKey: imageKey)
          DispatchQueue.main.async {
            complete(image)
          }
        }
      })
    }
  }
  
  public func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
    self.index = gallery.currentPage
    dismiss(animated: true, completion: nil)
  }
  
}

