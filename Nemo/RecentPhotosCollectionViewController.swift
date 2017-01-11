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

    fileprivate var selectedAssets: [PHAsset] {
        return self.collectionView?.indexPathsForSelectedItems?.map({ self.assetsFetchResults![$0.item] }) ?? []
    }

    fileprivate var assetsFetchResults: PHFetchResult<PHAsset>?
    fileprivate let maxFetchResultsCount = 70
    fileprivate let imageManager = PHCachingImageManager()
    fileprivate var cachingImageThumbnailSize = CGSize.zero
    fileprivate let collectionViewFlowLayout: UICollectionViewFlowLayout

    fileprivate var recentPhotosSection: Int = 0

    required init() {
        self.collectionViewFlowLayout = UICollectionViewFlowLayout()
        self.collectionViewFlowLayout.scrollDirection = .horizontal
        self.collectionViewFlowLayout.minimumLineSpacing = 4.0
        self.collectionViewFlowLayout.minimumInteritemSpacing = 4.0
        self.collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 6.0, left: 6.0, bottom: 6.0, right: 6.0)

        super.init(collectionViewLayout: collectionViewFlowLayout)

        self.addPhotoAction = UIAlertAction(title: String.localizedStringWithFormat(NSLocalizedString("Add %d Photos", tableName: "Nemo", bundle: Bundle.nemoBundle(), comment: ""), 0) as String, style: .default, handler: { (_) -> Void in
            self.delegate?.recentPhotosCollectionViewController(self, didFinishPickingPhotos: self.selectedAssets)
        })
        self.addPhotoAction.isEnabled = false
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.useLayoutToLayoutNavigationTransitions = false

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(RecentPhotosPhotoCollectionViewCell.self, forCellWithReuseIdentifier: reusePhotoIdentifier)

        // Do any additional setup after loading the view.
        self.collectionView!.backgroundColor = UIColor.clear
        self.collectionView!.allowsMultipleSelection = true
        self.collectionView!.showsHorizontalScrollIndicator = false
        self.collectionView!.showsVerticalScrollIndicator = false

        self.loadFetchResults()

        let cellMaxWidth = self.preferredContentSize.width - collectionViewFlowLayout.sectionInset.left - collectionViewFlowLayout.sectionInset.right
        let cellHeight = self.preferredContentSize.height - collectionViewFlowLayout.sectionInset.top - collectionViewFlowLayout.sectionInset.bottom
        self.collectionViewFlowLayout.itemSize = CGSize(width: cellHeight, height: cellHeight)
        self.cachingImageThumbnailSize = CGSize(width: cellMaxWidth, height: cellHeight)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let cellMaxWidth = size.width - collectionViewFlowLayout.sectionInset.left - collectionViewFlowLayout.sectionInset.right
        let cellHeight = size.height - collectionViewFlowLayout.sectionInset.top - collectionViewFlowLayout.sectionInset.bottom
        self.collectionViewFlowLayout.itemSize = CGSize(width: cellHeight, height: cellHeight)
        self.cachingImageThumbnailSize = CGSize(width: cellMaxWidth, height: cellHeight)
        self.collectionViewFlowLayout.invalidateLayout()
        self.resetCachedAssets()
        self.updateCachedAssets()
    }

    override func viewWillAppear(_ animated: Bool) {
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

    func loadFetchResults() {
        PHPhotoLibrary.requestAuthorization({ (status) -> Void in
            switch status {
            case .authorized:
                PHPhotoLibrary.shared().register(self)

                if let fetchedAssetCollection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumRecentlyAdded, options: nil).lastObject {
                    let fetchOptions = PHFetchOptions()
                    fetchOptions.predicate = NSPredicate(format: "SELF.mediaType = %d", PHAssetMediaType.image.rawValue)
                    fetchOptions.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false) ]
                    self.assetsFetchResults = PHAsset.fetchAssets(in: fetchedAssetCollection, options: fetchOptions)
                }

                self.updateCachedAssets()

                DispatchQueue.main.async(execute: { () -> Void in
                    self.collectionView!.reloadSections(IndexSet(integer: self.recentPhotosSection))
                })
                break
            default:
                break
            }
        })
    }

    // MARK: Asset Caching

    func resetCachedAssets() {
        self.imageManager.stopCachingImagesForAllAssets()
    }

    func updateCachedAssets() {
        let isViewVisible = self.isViewLoaded && (self.view?.window != nil)
        if isViewVisible {
            return
        }

        if self.collectionView != nil && (self.assetsFetchResults?.count ?? 0) > 0 {
            let imageRequestOptions = PHImageRequestOptions()

            if let assets = self.assetsFetchResults?.objects(at: IndexSet(integersIn: NSRange(location: 0, length: min(self.assetsFetchResults?.count ?? 0, self.maxFetchResultsCount)).toRange() ?? 0..<0)) {
                self.imageManager.startCachingImages(for: assets, targetSize: self.cachingImageThumbnailSize, contentMode: .aspectFit, options: imageRequestOptions)
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numberOfSections: Int = 0

        if self.recentPhotosSection >= 0 {
            numberOfSections += 1
        }

        return numberOfSections
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case self.recentPhotosSection:
            return min(self.assetsFetchResults?.count ?? 0, self.maxFetchResultsCount)
        default:
            fatalError("Unknown Section: \(section)")
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case self.recentPhotosSection:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusePhotoIdentifier, for: indexPath) as? RecentPhotosPhotoCollectionViewCell else { fatalError("Can't dequeue cell!") }

            // Configure the cell
            let currentTag = cell.tag + 1
            cell.tag = currentTag

            let asset = self.assetsFetchResults![indexPath.item]

            let imageRequestOptions = PHImageRequestOptions()
            imageRequestOptions.isNetworkAccessAllowed = true

            self.imageManager.requestImage(for: asset, targetSize: cachingImageThumbnailSize, contentMode: .aspectFill, options: imageRequestOptions) { (result, _) -> Void in
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let collectionViewLayout = collectionViewLayout as? UICollectionViewFlowLayout else { fatalError("It's not flow layout!") }
        
        switch indexPath.section {
        case self.recentPhotosSection:
            let asset = self.assetsFetchResults![indexPath.item]

            let itemCellHeight = collectionViewLayout.itemSize.height

            let pixelRatio = CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)

            return CGSize(width: pixelRatio * itemCellHeight, height: itemCellHeight)
        default:
            fatalError("Unknown IndexPath: \(indexPath)")
        }
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case self.recentPhotosSection:
            guard let cell = cell as? RecentPhotosPhotoCollectionViewCell else { fatalError("It's not RecentPhotosPhotoCollectionViewCell") }

            DispatchQueue.main.async(execute: { () -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    let layoutConstraint = NSLayoutConstraint(item: collectionView.superview!, attribute: .right, relatedBy: .greaterThanOrEqual, toItem: cell.checkIndicatorView, attribute: .right, multiplier: 1.0, constant: 4.0)
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

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.item) {
        default:
            let selectedItemsCount = collectionView.indexPathsForSelectedItems?.count ?? 0

            self.addPhotoAction.isEnabled = (selectedItemsCount != 0)
            self.addPhotoAction.setValue(String.localizedStringWithFormat(NSLocalizedString("Add %d Photos", tableName: "Nemo", bundle: Bundle.nemoBundle(), comment: ""), selectedItemsCount), forKey: "title")
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.item) {
        default:
            let selectedItemsCount = collectionView.indexPathsForSelectedItems?.count ?? 0

            self.addPhotoAction.isEnabled = (selectedItemsCount != 0)
            self.addPhotoAction.setValue(String.localizedStringWithFormat(NSLocalizedString("Add %d Photos", tableName: "Nemo", bundle: Bundle.nemoBundle(), comment: ""), selectedItemsCount), forKey: "title")
        }
    }

    // MARK: -
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.updateCachedAssets()
    }

    // MARK: PHPhotoLibraryChangeObserver
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async(execute: {
            guard let assetsFetchResults = self.assetsFetchResults else { return }

            if let collectionChanges = changeInstance.changeDetails(for: assetsFetchResults) {
                self.assetsFetchResults = collectionChanges.fetchResultAfterChanges

                if let collectionView = self.collectionView, self.recentPhotosSection > 0 {
                    if !collectionChanges.hasIncrementalChanges || collectionChanges.hasMoves {
                        self.collectionView!.reloadSections(IndexSet(integer: self.recentPhotosSection))
                    } else {
                        var selectedIndexPaths = Set<IndexPath>(self.collectionView!.indexPathsForSelectedItems ?? [])

                        collectionView.performBatchUpdates({ () -> Void in
                            let removedIndexes = (collectionChanges.removedIndexes as NSIndexSet?)?.indexes(options: .concurrent, passingTest: { (index, _) -> Bool in
                                return index < self.maxFetchResultsCount
                            }) ?? IndexSet()
                            if removedIndexes.count > 0 {
                                collectionView.deleteItems(at: removedIndexes.map({ IndexPath(item: $0, section: self.recentPhotosSection) }))
                                collectionView.insertItems(at: IndexSet(integersIn: NSRange(location: self.maxFetchResultsCount - removedIndexes.count, length: removedIndexes.count - max(self.maxFetchResultsCount - self.assetsFetchResults!.count, 0)).toRange() ?? 0..<0).map({ IndexPath(item: $0, section: self.recentPhotosSection) }))
                            }

                            let insertedindexes = (collectionChanges.insertedIndexes as NSIndexSet?)?.indexes(options: .concurrent, passingTest: { (index, _) -> Bool in
                                return index < self.maxFetchResultsCount
                            }) ?? IndexSet()
                            if insertedindexes.count > 0 {
                                collectionView.insertItems(at: insertedindexes.map({ IndexPath(item: $0, section: self.recentPhotosSection) }))
                                collectionView.deleteItems(at: IndexSet(integersIn: NSRange(location: self.maxFetchResultsCount - insertedindexes.count, length: insertedindexes.count).toRange() ?? 0..<0).map({ IndexPath(item: $0, section: self.recentPhotosSection) }))
                            }

                            let chanagedIndexes = (collectionChanges.changedIndexes as NSIndexSet?)?.indexes(options: .concurrent, passingTest: { (index, _) -> Bool in
                                return index < self.maxFetchResultsCount
                            }) ?? IndexSet()
                            if chanagedIndexes.count > 0 {
                                let chanagedIndexPaths = chanagedIndexes.map({ IndexPath(item: $0, section: self.recentPhotosSection) })

                                selectedIndexPaths.formIntersection(Set<IndexPath>(chanagedIndexPaths))
                                collectionView.reloadItems(at: chanagedIndexPaths)
                            }
                            }, completion: { (_) -> Void in
                                for indexPath in selectedIndexPaths {
                                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
                                }

                                self.resetCachedAssets()
                        })
                    }
                }
            }
        })
    }

}
