//
//  ViewController.swift
//  AffirmSearchFlickr
//
//  Created by Joe Bradley on 11/12/18.
//  Copyright © 2018 Affirm. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: IB outlet vars

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Constants and vars
    
    let imageCellIdentifier = "imageCellIdentifier"
    let imageViewSegue = "imageViewSegue"
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.allowsSelection = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.isSelected = false
        self.performSegue(withIdentifier: imageViewSegue, sender: nil)
    }
    
    // MARK: Collection view data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell = self.collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath) as! CollectionViewCell

        imageCell.imageView.image = UIImage.init(named: "imagePlaceholder")
        
        return imageCell as UICollectionViewCell
    }
    

}

