//
//  PhotoItemCell.swift
//  CollectionDemo
//
//  Created by Zhou Hao on 7/2/18.
//  Copyright © 2018 Zhou Hao. All rights reserved.
//

import UIKit

class PhotoItemCell: UICollectionViewCell {
  
  fileprivate static let iconSize: CGFloat = 32
  fileprivate static let iconMargin: CGFloat = 5
  
  var imageView: UIImageView!
  fileprivate var selectedImageView = UIImageView()
  override var isSelected: Bool {
    didSet {
      selectedImageView.isHidden = !isSelected
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let bundle = Bundle(url: Bundle(for: PhotoItemCell.self).url(forResource: "WOWGallery", withExtension: "bundle")!)!
    let image = UIImage(named: "SelectedIcon", in: bundle, compatibleWith: nil)
    selectedImageView.image = image
    selectedImageView.isHidden = true
    
    imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    self.addSubview(imageView)
    
    self.addSubview(selectedImageView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    imageView?.frame = self.bounds
    let origin = CGPoint(x: self.bounds.width - PhotoItemCell.iconSize - PhotoItemCell.iconMargin, y: self.bounds.height - PhotoItemCell.iconSize - PhotoItemCell.iconMargin)
    selectedImageView.frame = CGRect(origin: origin , size: CGSize(width: PhotoItemCell.iconSize, height: PhotoItemCell.iconSize))
  }
  
}
