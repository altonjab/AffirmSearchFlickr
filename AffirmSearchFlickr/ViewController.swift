//
//  ViewController.swift
//  AffirmSearchFlickr
//
//  Created by Joe Bradley on 11/12/18.
//  Copyright © 2018 Affirm. All rights reserved.
//

import UIKit
import AFNetworking
import SDWebImage

class ViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: IB outlet vars

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Constants and vars
    
    let imageCellIdentifier = "imageCellIdentifier"
    let imageViewControllerID = "imageViewControllerID"
    let placeholderImage = "placeholderImage"
    
    static let defaultNumberOfResultSets = 2

    // TODO: Override imageDataArray setter to store results for search text
    //          to allow for offline search results
    
    var imageDataArray = [AnyObject]()
    var numberOfResultSets = defaultNumberOfResultSets
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Check if offline and display message
        // TODO: Show recent searches that match cached results
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // TODO: Clear out cached images and/or data
    }
    
    // MARK: Search bar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Reset numberOfResultSets
        numberOfResultSets = ViewController.defaultNumberOfResultSets
        
        if searchText.trimmingCharacters(in: .illegalCharacters) != "" {
            // Search flickr
            self.searchFlickr(withText: searchText)
        }
        
        else {
            // Reset search results
            self.imageDataArray = [AnyObject]()
            self.collectionView.reloadData()
        }
    }

    // MARK: Collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Deselect cell
        collectionView.cellForItem(at: indexPath)?.isSelected = false
        
        let arrayIndex = self.fetchArrayIndex(forIndexPath: indexPath)
        
        guard let imageURLPath = self.imageDataArray[arrayIndex]["url_s"] as? String else {
            return
        }
        
        let imageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: self.imageViewControllerID)  as! ImageViewController

        // Set image url path
        imageViewController.imageViewURLPath = imageURLPath

        // Push image view controller
        self.navigationController?.pushViewController(imageViewController, animated: true)
    }
    
    // MARK: Collection view data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageDataArray.count * self.numberOfResultSets
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (self.collectionView.cellForItem(at: indexPath) as? CollectionViewCell) != nil {
            (self.collectionView.cellForItem(at: indexPath) as! CollectionViewCell).imageView.image = UIImage.init(named: "imagePlaceholder")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath) as! CollectionViewCell
        let arrayIndex = self.fetchArrayIndex(forIndexPath: indexPath)

        // Setup url from image data array for index
        if let imageURLPath = self.imageDataArray[arrayIndex]["url_s"] as? String {
            
            // Setup cached image
            let cacheKey: String = imageURLPath
            var cachedImage = SDImageCache.shared().imageFromDiskCache(forKey: cacheKey)
            
            if cachedImage == nil {
                cachedImage = SDImageCache.shared().imageFromMemoryCache(forKey: cacheKey)
            }
            
            if cachedImage != nil {
                // Use cached image
                imageCell.imageView.image = cachedImage
            }

            else {
                // Setup image for url
                let imageURL = URL.init(string: imageURLPath)
                
                imageCell.imageView.sd_setImage(with: imageURL,
                                                placeholderImage: UIImage.init(named: placeholderImage),
                                                options: SDWebImageOptions(),
                                                completed: nil)
            }
        }
        
        else {
            imageCell.imageView.image = UIImage.init(named: "imagePlaceholder")
        }
        
        // Increment number of result sets if near the end of result set (if not already increased)
        let thresholdRowCount = ((self.imageDataArray.count - 1) * (self.numberOfResultSets - 1))
        
        // TODO: Check that number of results sets not already accounted for to avoid incrementing unneccisarily
        if indexPath.row >= thresholdRowCount {
            self.numberOfResultSets += 1
            
            // TODO: Reload only cells that exist beyond threshold
            self.collectionView.reloadData()
        }
        
        return imageCell as UICollectionViewCell
    }
    
    // MARK: Custom
    
    func fetchArrayIndex(forIndexPath indexPath: IndexPath) -> Int {
        var arrayIndex = 0
        
        // Use number of instances of result set to figure out which index in results array
        if indexPath.row < self.imageDataArray.count {
            arrayIndex = indexPath.row
        }
            
        else {
            // Get the remainder of the modulus of row times instance for array count
            arrayIndex = (self.numberOfResultSets * indexPath.row) % self.imageDataArray.count
        }
        
        return arrayIndex
    }

    func fetchSearchURLPath(withText searchText: String) -> String {
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=675894853ae8ec6c242fa4c077bcf4a0&text=\(searchText)&extras=url_s&format=json&nojsoncallback=1"
    }
    
    func searchFlickr(withText searchText: String) {
        let manager = AFHTTPSessionManager()
        let urlPath = self.fetchSearchURLPath(withText: searchText)
        
        //print("response = \(String(describing: response))")

        // TODO: Display activity indicator
        
        manager.responseSerializer = AFJSONResponseSerializer()
        
        manager.get(urlPath, parameters: nil, progress: nil, success: { (task, response) in
            guard let responseDictionary = response as? [String: AnyObject] else {
                self.imageDataArray = [AnyObject]()
                return
            }
            guard let photosDictionary = responseDictionary["photos"] as? [String: AnyObject] else {
                self.imageDataArray = [AnyObject]()
                return
            }
            guard let photosArray = photosDictionary["photo"] as? [AnyObject] else {
                self.imageDataArray = [AnyObject]()
                return
            }
            
            print("count = \(photosArray.count)")

            // Set image data array
            self.imageDataArray = photosArray

            // TODO: Hide activity indicator
            
            // Reload collection view for new data
            self.collectionView.reloadData()

        }) { (task, error) in
            // Reset image data array
            self.imageDataArray = [AnyObject]()

            // TODO: Display error to user
            // TODO: Hide activity indicator
            print("error = \(error)")
            
            // Reload collection view for empty data
            self.collectionView.reloadData()
        }
    }
}

