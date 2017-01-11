//
//  NSBundle.swift
//  
//
//  Created by Sinoru on 2015. 8. 10..
//
//

import UIKit

extension Bundle {

    class func nemoBundle() -> Bundle {
        return Bundle(for: PhotosMenuController.self)
    }
}
