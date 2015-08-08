//
//  PhotosMenuControllerDelegate.swift
//  Nemo
//
//  Created by Sinoru on 2015. 8. 8..
//  Copyright (c) 2015년 Sinoru. All rights reserved.
//

import UIKit
import Photos

@objc(NMPhotosMenuControllerDelegate)
public protocol PhotosMenuControllerDelegate: NSObjectProtocol {
    optional func photosMenuController(controller: PhotosMenuController, didFinishPickingPhotos photos: [PHAsset])
    optional func photosMenuControllerDidCancel(controller: PhotosMenuController)
}
