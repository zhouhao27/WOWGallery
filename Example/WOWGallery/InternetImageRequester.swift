//
//  InternetImageRequester.swift
//  CollectionDemo
//
//  Created by Zhou Hao on 7/2/18.
//  Copyright © 2018 Zhou Hao. All rights reserved.
//

import UIKit

class InternetImageRequester: ImageRequester {
  
  static let total = 3000
  
  let baseUrl = URL(string: "https://placehold.it")!
  var tasks = [URLSessionDataTask?](repeating: nil, count: InternetImageRequester.total)
  var thumbnailTasks = [URLSessionDataTask?](repeating: nil, count: InternetImageRequester.total)
  
  func requestCount(complete:@escaping (Int) -> ()) {
    complete(InternetImageRequester.total)
  }
  
  func requestThumbnail(index: Int, complete:@escaping (UIImage?)->()) {
    
    if thumbnailTasks[index] != nil && thumbnailTasks[index]!.state == URLSessionTask.State.running {
      // it's still running, no need to return anything
      return
    }
    
    let imgURL = urlComponents(index: index, isThumbnail: true)
    let task = getTask(url: imgURL, index: index, complete: complete)
    thumbnailTasks[index] = task
    task.resume()
  }
  
  func requestImage(index: Int, complete:@escaping (UIImage?)->()) {
    if tasks[index] != nil && tasks[index]!.state == URLSessionTask.State.running {
      // it's still running, no need to return anything
      return
    }
    
    let imgURL = urlComponents(index: index, isThumbnail: false)
    let task = getTask(url: imgURL, index: index, complete: complete)
    tasks[index] = task
    task.resume()
  }

  func getTask(url: URL, index: Int, complete: @escaping (UIImage?)->()) -> URLSessionDataTask {
    return URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, error == nil else {
        complete(nil)
        return
      }
      let image = UIImage(data: data)!
      DispatchQueue.main.async() {
        complete(image)
      }
    }
  }
  
  func cancelImageRequest(index: Int) {
    if index < tasks.count {
      let task = tasks[index]
      task?.cancel()
    }
  }
  
  func cancelThumbnailRequest(index: Int) {
    if index < thumbnailTasks.count {
      let task = thumbnailTasks[index]
      task?.cancel()
    }
  }
  
  private func urlComponents(index: Int, isThumbnail: Bool) -> URL {
    var baseUrlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
    baseUrlComponents?.path = isThumbnail ? "/128x128" : "/1024x1024)"
    baseUrlComponents?.query = "text=food \(index)"
    return (baseUrlComponents?.url)!
  }

}
