//
//  ImageRequester.swift
//  CollectionDemo
//
//  Created by Zhou Hao on 6/2/18.
//  Copyright © 2018 Zhou Hao. All rights reserved.
//

import UIKit

protocol ImageRequester: class {
  func requestCount(complete:@escaping (Int) -> ())
  func requestThumbnail(index: Int, complete:@escaping (UIImage?)->())
  func requestImage(index: Int, complete:@escaping (UIImage?)->())
  func cancelImageRequest(index: Int)
  func cancelThumbnailRequest(index: Int)
}
