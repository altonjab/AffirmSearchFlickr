//
//  ImageViewController.swift
//  AffirmSearchFlickr
//
//  Created by Joe Bradley on 11/12/18.
//  Copyright © 2018 Affirm. All rights reserved.
//

import UIKit
import SDWebImage

class ImageViewController: UIViewController {

    // MARK: IB outlet vars

    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Constants and vars
    
    let placeholderImage = "placeholderImage"

    var imageViewURLPath :String?
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.imageViewURLPath != nil {
            
            // NOTE: Copied cached code from ViewController
            // TODO: Create a shared function setting up cached image
            
            // Setup cached image
            let cacheKey: String = self.imageViewURLPath!
            var cachedImage = SDImageCache.shared().imageFromDiskCache(forKey: cacheKey)
            
            if cachedImage == nil {
                cachedImage = SDImageCache.shared().imageFromMemoryCache(forKey: cacheKey)
            }
            
            if cachedImage != nil {
                // Use cached image
                self.imageView.image = cachedImage
            }
                
            else {
                // Setup image for url
                let imageURL = URL.init(string: self.imageViewURLPath!)
                
                self.imageView.sd_setImage(with: imageURL,
                                           placeholderImage: UIImage.init(named: placeholderImage),
                                           options: SDWebImageOptions(),
                                           completed: nil)
            }
        }
        
        else {
            self.imageView.image = UIImage.init(named: "imagePlaceholder")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
