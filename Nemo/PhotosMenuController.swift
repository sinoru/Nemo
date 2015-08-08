//
//  PhotosMenuController.swift
//  Nemo
//
//  Created by Sinoru on 2015. 8. 8..
//  Copyright (c) 2015년 Sinoru. All rights reserved.
//

import UIKit
import MobileCoreServices

@objc(NMPhotosMenuController)
public class PhotosMenuController: UIAlertController, UIPopoverPresentationControllerDelegate {

    public var delegate: protocol<PhotosMenuControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>?
    
    private var recentPhotosCollectionViewController: RecentPhotosCollectionViewController!
    
    private var photoLibraryAction: UIAlertAction!
    private var cameraAction: UIAlertAction!
    private var cancelAction: UIAlertAction!
    private var customActions: Array<UIAlertAction> = []
    
    private var capturedPresentingViewController: UIViewController?
    private var capturedPopoverPresentationControllerBarButtonItem: UIBarButtonItem?
    private var capturedPopoverPresentationControllerSourceView: UIView?
    private var capturedPopoverPresentationControllerSourceRect: CGRect?
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.recentPhotosCollectionViewController = RecentPhotosCollectionViewController()
        self.recentPhotosCollectionViewController.preferredContentSize = CGSize(width: 0.0, height: 180.0)
        
        self.photoLibraryAction = UIAlertAction(title: "Photo Library", style: .Default, handler: { (action) -> Void in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self.delegate
            imagePickerController.modalPresentationStyle = .Popover
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .PhotoLibrary
            imagePickerController.mediaTypes = [kUTTypeImage as String]
            
            imagePickerController.popoverPresentationController?.barButtonItem = self.capturedPopoverPresentationControllerBarButtonItem
            imagePickerController.popoverPresentationController?.sourceView = self.capturedPopoverPresentationControllerSourceView
            imagePickerController.popoverPresentationController?.sourceRect = self.capturedPopoverPresentationControllerSourceRect ?? CGRectZero
            
            self.capturedPresentingViewController?.presentViewController(imagePickerController, animated: true, completion: nil)
        })
        
        self.cameraAction = UIAlertAction(title: "Take Photo or Video", style: .Default, handler: { (action) -> Void in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self.delegate
            
            self.capturedPresentingViewController?.presentViewController(imagePickerController, animated: true, completion: nil)
        })
        
        self.cancelAction = UIAlertAction(title: "Cancel", style: .Cancel,  handler: { (action) -> Void in
            self.delegate?.photosMenuControllerDidCancel?(self)
        })
    }
    
    public override func viewWillAppear(animated: Bool) {
        self.setValue(self.recentPhotosCollectionViewController, forKey: "contentViewController")
        
        super.addAction(self.photoLibraryAction)
        super.addAction(self.cameraAction)
        
        for action in customActions {
            super.addAction(action)
        }
        
        super.addAction(self.cancelAction)
        
        super.viewWillAppear(animated)
        
        self.capturedPresentingViewController = self.presentingViewController
        self.capturedPopoverPresentationControllerBarButtonItem = self.popoverPresentationController?.barButtonItem
        self.capturedPopoverPresentationControllerSourceRect = self.popoverPresentationController?.sourceRect
        self.capturedPopoverPresentationControllerSourceView = self.popoverPresentationController?.sourceView
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func addAction(action: UIAlertAction) {
        customActions += [action]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
