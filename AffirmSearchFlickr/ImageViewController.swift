//
//  ImageViewController.swift
//  AffirmSearchFlickr
//
//  Created by Joe Bradley on 11/12/18.
//  Copyright © 2018 Affirm. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = UIImage.init(named: "imagePlaceholder")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        self.imageView.image = UIImage.init(named: "imagePlaceholder")
//    }
}
