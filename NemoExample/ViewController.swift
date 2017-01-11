//
//  ViewController.swift
//  NemoExample
//
//  Created by Sinoru on 2015. 8. 8..
//  Copyright (c) 2015년 Sinoru. All rights reserved.
//

import UIKit
import Nemo

let reuseIdentifier = "Cell"

class ViewController: UICollectionViewController, PhotosMenuControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var images: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addPhotos(_ sender: AnyObject) {
        let photosMenuController = Nemo.PhotosMenuController()
        photosMenuController.delegate = self

        if let popoverPresentationController = photosMenuController.popoverPresentationController {
            popoverPresentationController.barButtonItem = sender as? UIBarButtonItem
        }

        self.present(photosMenuController, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell

        // Configure the cell
        cell.imageView.image = self.images[indexPath.row]

        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

    // MARK: PhotosMenuControllerDelegate
    func photosMenuController(_ controller: PhotosMenuController, didPickPhotos photos: [PHAsset]) {
        for photo in photos {
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isSynchronous = true

            PHImageManager.default().requestImage(for: photo, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFill, options: options, resultHandler: { (result, _) -> Void in
                if let result = result {
                    self.images.append(result)
                }
            })
        }

        self.collectionView!.reloadData()
    }

    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.images.append(image)
            self.collectionView!.reloadData()
        }

        picker.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
