//
//  NSBundle.swift
//  
//
//  Created by Sinoru on 2015. 8. 10..
//
//

import UIKit

extension NSBundle {
   
    class func nemoBundle() -> NSBundle {
        return NSBundle(forClass: PhotosMenuController.self)
    }
}
