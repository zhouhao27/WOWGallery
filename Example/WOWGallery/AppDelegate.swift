//
//  AppDelegate.swift
//  PhotoGallery
//
//  Created by zhouhao27 on 02/07/2018.
//  Copyright (c) 2018 zhouhao27. All rights reserved.
//

import UIKit
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    requestAuthorization()
    return true
  }
  
  func requestAuthorization() {
    // TODO: To rerequest when user select NO
    PHPhotoLibrary.requestAuthorization({ (status) in
      if status != .authorized {
        let alert = UIAlertController(title: "Photos Access Denied", message: "App needs access to photo library.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
      }
    })
  }


}

