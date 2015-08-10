//
//  RecentPhotosCollectionViewController.swift
//  
//
//  Created by Sinoru on 2015. 8. 8..
//
//

import UIKit
import Photos

private let reusePhotoIdentifier = "PhotoCell"

class RecentPhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, PHPhotoLibraryChangeObserver, UIImagePickerControllerDelegate {

    var addPhotoAction: UIAlertAction!
    var delegate: RecentPhotosCollectionViewControllerDelegate?
    
    private var selectedAssets: [PHAsset] {
        return (self.collectionView?.indexPathsForSelectedItems() as? [NSIndexPath])?.map({ self.assetsFetchResults[$0.item] as! PHAsset }) ?? []
    }
    
    private var assetsFetchResults: PHFetchResult!
    private let maxFetchResultsCount = 70
    private let imageManager = PHCachingImageManager()
    private var cachingImageThumbnailSize = CGSizeZero
    private let collectionViewFlowLayout: UICollectionViewFlowLayout
    
    private var recentPhotosSection: Int = 0
    
    required init() {
        self.collectionViewFlowLayout = UICollectionViewFlowLayout()
        self.collectionViewFlowLayout.scrollDirection = .Horizontal
        self.collectionViewFlowLayout.minimumLineSpacing = 4.0
        self.collectionViewFlowLayout.minimumInteritemSpacing = 4.0
        self.collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 6.0, left: 6.0, bottom: 6.0, right: 6.0)
        
        super.init(collectionViewLayout: collectionViewFlowLayout)
        
        self.addPhotoAction = UIAlertAction(title: NSString.localizedStringWithFormat(NSLocalizedString("Add %d Photos", bundle: NSBundle.nemoBundle(), comment: ""), 0) as String, style: .Default, handler: { (action) -> Void in
            self.delegate?.recentPhotosCollectionViewController(self, didFinishPickingPhotos: self.selectedAssets)
        })
        self.addPhotoAction.enabled = false
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.useLayoutToLayoutNavigationTransitions = false

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(RecentPhotosPhotoCollectionViewCell.self, forCellWithReuseIdentifier: reusePhotoIdentifier)

        // Do any additional setup after loading the view.
        self.collectionView!.backgroundColor = UIColor.clearColor()
        self.collectionView!.allowsMultipleSelection = true
        self.collectionView!.showsHorizontalScrollIndicator = false
        self.collectionView!.showsVerticalScrollIndicator = false
        
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
            if let fetchedAssetCollection = PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .SmartAlbumRecentlyAdded, options: nil)?.lastObject as? PHAssetCollection {
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "SELF.mediaType = %d", PHAssetMediaType.Image.rawValue)
                fetchOptions.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false) ]
                self.assetsFetchResults = PHAsset.fetchAssetsInAssetCollection(fetchedAssetCollection, options: fetchOptions)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if self.assetsFetchResults != nil {
                    self.collectionView!.reloadSections(NSIndexSet(index: self.recentPhotosSection))
                }
            })
        })
        
        let cellMaxWidth = self.preferredContentSize.width - collectionViewFlowLayout.sectionInset.left - collectionViewFlowLayout.sectionInset.right
        let cellHeight = self.preferredContentSize.height - collectionViewFlowLayout.sectionInset.top - collectionViewFlowLayout.sectionInset.bottom
        self.collectionViewFlowLayout.itemSize = CGSize(width: cellHeight, height: cellHeight)
        self.cachingImageThumbnailSize = CGSize(width: cellMaxWidth, height: cellHeight)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        let cellMaxWidth = size.width - collectionViewFlowLayout.sectionInset.left - collectionViewFlowLayout.sectionInset.right
        let cellHeight = size.height - collectionViewFlowLayout.sectionInset.top - collectionViewFlowLayout.sectionInset.bottom
        self.collectionViewFlowLayout.itemSize = CGSize(width: cellHeight, height: cellHeight)
        self.cachingImageThumbnailSize = CGSize(width: cellMaxWidth, height: cellHeight)
        self.collectionViewFlowLayout.invalidateLayout()
        self.resetCachedAssets()
        self.updateCachedAssets()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateCachedAssets()
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
    
    // MARK: Asset Caching
    
    func resetCachedAssets() {
        self.imageManager.stopCachingImagesForAllAssets()
    }
    
    func updateCachedAssets() {
        let isViewVisible = self.isViewLoaded() && (self.view?.window != nil)
        if isViewVisible {
            return
        }
        
        if let collectionView = self.collectionView where self.assetsFetchResults?.count > 0 {
            let imageRequestOptions = PHImageRequestOptions()
            
            self.imageManager.startCachingImagesForAssets(self.assetsFetchResults.objectsAtIndexes(NSIndexSet(indexesInRange: NSRange(location: 0, length: min(self.assetsFetchResults.count, self.maxFetchResultsCount)))), targetSize: self.cachingImageThumbnailSize, contentMode: .AspectFit, options: imageRequestOptions)
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        var numberOfSections: Int = 0
        
        if self.recentPhotosSection >= 0 {
            numberOfSections++
        }
        
        return numberOfSections
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case self.recentPhotosSection:
            return min(self.assetsFetchResults?.count ?? 0, self.maxFetchResultsCount)
        default:
            fatalError("Unknown Section: \(section)")
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case self.recentPhotosSection:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reusePhotoIdentifier, forIndexPath: indexPath) as! RecentPhotosPhotoCollectionViewCell
            
            // Configure the cell
            let currentTag = cell.tag + 1
            cell.tag = currentTag
            
            let asset = self.assetsFetchResults[indexPath.item] as! PHAsset
            
            let imageRequestOptions = PHImageRequestOptions()
            imageRequestOptions.networkAccessAllowed = true
            
            self.imageManager.requestImageForAsset(asset, targetSize: cachingImageThumbnailSize, contentMode: .AspectFill, options: imageRequestOptions) { (result, info) -> Void in
                if cell.tag == currentTag {
                    cell.image = result
                }
            }
            
            return cell
        default:
            fatalError("Unknown IndexPath: \(indexPath)")
        }
    }
    
    // MARK: -
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        switch indexPath.section {
        case self.recentPhotosSection:
            let asset = self.assetsFetchResults[indexPath.item] as! PHAsset
            
            let itemCellHeight = (collectionViewLayout as! UICollectionViewFlowLayout).itemSize.height
            
            let pixelRatio = CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)
            
            return CGSize(width: pixelRatio * itemCellHeight, height: itemCellHeight)
        default:
            fatalError("Unknown IndexPath: \(indexPath)")
        }
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case self.recentPhotosSection:
            let cell = cell as! RecentPhotosPhotoCollectionViewCell
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let layoutConstraint = NSLayoutConstraint(item: collectionView.superview!, attribute: .Right, relatedBy: .GreaterThanOrEqual, toItem: cell.checkIndicatorView, attribute: .Right, multiplier: 1.0, constant: 4.0)
                    layoutConstraint.priority = 750
                    collectionView.superview!.addConstraint(layoutConstraint)
                })
            })
        default:
            break
        }
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
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.item) {
        default:
            self.addPhotoAction.enabled = (collectionView.indexPathsForSelectedItems().count != 0)
            self.addPhotoAction.setValue(NSString.localizedStringWithFormat(NSLocalizedString("Add %d Photos", bundle: NSBundle.nemoBundle(), comment: ""), collectionView.indexPathsForSelectedItems().count), forKey: "title")
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.item) {
        default:
            self.addPhotoAction.enabled = (collectionView.indexPathsForSelectedItems().count != 0)
            self.addPhotoAction.setValue(NSString.localizedStringWithFormat(NSLocalizedString("Add %d Photos", bundle: NSBundle.nemoBundle(), comment: ""), collectionView.indexPathsForSelectedItems().count), forKey: "title")
        }
    }
    
    // MARK: -
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.updateCachedAssets()
    }
    
    // MARK: PHPhotoLibraryChangeObserver
    func photoLibraryDidChange(changeInstance: PHChange!) {
        dispatch_async(dispatch_get_main_queue(), {
            if let collectionChanges = changeInstance.changeDetailsForFetchResult(self.assetsFetchResults) {
                self.assetsFetchResults = collectionChanges.fetchResultAfterChanges
                
                if let collectionView = self.collectionView where self.recentPhotosSection > 0 {
                    if !collectionChanges.hasIncrementalChanges || collectionChanges.hasMoves {
                        self.collectionView!.reloadSections(NSIndexSet(index: self.recentPhotosSection))
                    }
                    else {
                        var selectedIndexPaths = Set<NSIndexPath>(self.collectionView!.indexPathsForSelectedItems() as! [NSIndexPath])
                        
                        collectionView.performBatchUpdates({ () -> Void in
                            let removedIndexes = collectionChanges.removedIndexes?.indexesWithOptions(.Concurrent, passingTest: { (index, stop) -> Bool in
                                return index < self.maxFetchResultsCount
                            }) ?? NSIndexSet()
                            if removedIndexes.count > 0 {
                                collectionView.deleteItemsAtIndexPaths(map(removedIndexes, { NSIndexPath(forItem: $0, inSection: self.recentPhotosSection) }))
                                collectionView.insertItemsAtIndexPaths(map(NSIndexSet(indexesInRange: NSRange(location: self.maxFetchResultsCount - removedIndexes.count, length: removedIndexes.count - max(self.maxFetchResultsCount - self.assetsFetchResults.count, 0))), { NSIndexPath(forItem: $0, inSection: self.recentPhotosSection) }))
                            }
                            
                            let insertedindexes = collectionChanges.insertedIndexes?.indexesWithOptions(.Concurrent, passingTest: { (index, stop) -> Bool in
                                return index < self.maxFetchResultsCount
                            }) ?? NSIndexSet()
                            if insertedindexes.count > 0 {
                                collectionView.insertItemsAtIndexPaths(map(insertedindexes, { NSIndexPath(forItem: $0, inSection: self.recentPhotosSection) }))
                                collectionView.deleteItemsAtIndexPaths(map(NSIndexSet(indexesInRange: NSRange(location: self.maxFetchResultsCount - insertedindexes.count, length: insertedindexes.count)), { NSIndexPath(forItem: $0, inSection: self.recentPhotosSection) }))
                            }
                            
                            let chanagedIndexes = collectionChanges.changedIndexes?.indexesWithOptions(.Concurrent, passingTest: { (index, stop) -> Bool in
                                return index < self.maxFetchResultsCount
                            }) ?? NSIndexSet()
                            if chanagedIndexes.count > 0 {
                                let chanagedIndexPaths = map(chanagedIndexes, { NSIndexPath(forItem: $0, inSection: self.recentPhotosSection) }) as! [NSIndexPath]
                                
                                selectedIndexPaths.intersectInPlace(Set<NSIndexPath>(chanagedIndexPaths))
                                collectionView.reloadItemsAtIndexPaths(chanagedIndexPaths)
                            }
                            }, completion: { (finished) -> Void in
                                for indexPath in selectedIndexPaths{
                                    collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
                                }
                                
                                self.resetCachedAssets()
                        })
                    }
                    
                    
                }
            }
        })
    }

}
