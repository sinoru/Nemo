//
//  PhotosMenuControllerDelegate.swift
//  Nemo
//
//  Created by Sinoru on 2015. 8. 8..
//  Copyright (c) 2015년 Sinoru. All rights reserved.
//

import UIKit
import Photos

/// The PhotosMenuControllerDelegate protocol defines methods that your delegate object must implement to interact with the photos menu interface. The methods of this protocol notify your delegate when the user either picks photos or image picker, or cancels the menu.
@objc(NMPhotosMenuControllerDelegate)
public protocol PhotosMenuControllerDelegate: NSObjectProtocol {
    /**
    Tells the delegate that the user picked photos
    
    :param: controller The controller object managing the menu
    :param: photos A array containing photos as PHAsset
    */
    optional func photosMenuController(controller: PhotosMenuController, didPickPhotos photos: [PHAsset])
    /**
    Tells the delegate that the user picked image picker
    
    :param: controller The controller object managing the menu
    :param: imagePicker The controller object that user picked
    */
    optional func photosMenuController(controller: PhotosMenuController, didPickImagePicker imagePicker: UIImagePickerController)
    /**
    Tells the delegate that the user canceled
    
    :param: controller The controller object managing the menu
    */
    optional func photosMenuControllerDidCancel(controller: PhotosMenuController)
}
