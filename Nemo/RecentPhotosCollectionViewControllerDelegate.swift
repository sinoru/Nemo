//
//  RecentPhotosCollectionViewControllerDelegate.swift
//  
//
//  Created by Sinoru on 2015. 8. 10..
//
//

import UIKit

protocol RecentPhotosCollectionViewControllerDelegate: class {
   func recentPhotosCollectionViewController(_ controller: RecentPhotosCollectionViewController, didFinishPickingPhotos photos: [PHAsset])
}
