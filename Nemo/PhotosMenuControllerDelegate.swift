//
//  PhotosMenuControllerDelegate.swift
//  Nemo
//
//  Created by Sinoru on 2015. 8. 8..
//  Copyright © 2015-2017 Sinoru. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//  http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

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
    @objc optional func photosMenuController(_ controller: PhotosMenuController, didPickPhotos photos: [PHAsset])

    /**
    Tells the delegate that the user picked image picker
    
    :param: controller The controller object managing the menu
    :param: imagePicker The controller object that user picked
    */
    @objc optional func photosMenuController(_ controller: PhotosMenuController, didPickImagePicker imagePicker: UIImagePickerController)

    /**
    Tells the delegate that the user canceled
    
    :param: controller The controller object managing the menu
    */
    @objc optional func photosMenuControllerDidCancel(_ controller: PhotosMenuController)

}
