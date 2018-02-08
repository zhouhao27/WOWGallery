//
//  PhotoAlbumRequester.swift
//  CollectionDemo
//
//  Created by Zhou Hao on 7/2/18.
//  Copyright © 2018 Zhou Hao. All rights reserved.
//

import UIKit
import Photos

class PhotoAlbumRequester: ImageRequester {
  
  var fetchResult: PHFetchResult<PHAsset>?
  
  func requestCount(complete:@escaping (Int) -> ()) {
    
    DispatchQueue.global(qos: .background).async {
      let fetchOptions = PHFetchOptions()
      fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate",ascending:false)]
      
      self.fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
      
      DispatchQueue.main.async {
        complete(self.fetchResult?.count ?? 0)
      }
    }
  }
  
  func requestThumbnail(index: Int, complete:@escaping (UIImage?)->()) {
    request(index: index, isThumbnail: true, complete: complete)
  }
  
  func requestImage(index: Int, complete:@escaping (UIImage?)->()) {
    request(index: index, isThumbnail: false, complete: complete)
  }
  
  func cancelImageRequest(index: Int) {
    cancelRequest(index: index)
  }
  
  func cancelThumbnailRequest(index: Int) {
    cancelRequest(index: index)
  }
  
  private func request(index: Int, isThumbnail: Bool, complete:@escaping (UIImage?)->()) {
    DispatchQueue.global(qos: .background).async {
      let imgMgr = PHImageManager.default()
      if index < self.fetchResult?.count ?? 0 {
        let reqOpts = PHImageRequestOptions()
        reqOpts.isSynchronous = false
        reqOpts.deliveryMode = isThumbnail ? .fastFormat : .highQualityFormat
        
        let size = isThumbnail ? CGSize(width: 256, height: 256) : CGSize(width: 1024, height: 1024)
        imgMgr.requestImage(for: self.fetchResult!.object(at: index), targetSize: size, contentMode: .aspectFill, options: reqOpts, resultHandler: { (image, error) in
          DispatchQueue.main.async {
            complete(image)
            return
          }
        })
      }
      DispatchQueue.main.async {
        complete(nil)
      }
    }
  }
  
  private func cancelRequest(index: Int) {
    
  }
}
