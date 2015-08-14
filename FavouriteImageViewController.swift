//
//  FavouriteImageViewController.swift
//  Flick
//
//  Created by JohnMajor on 8/11/15.
//  Copyright (c) 2015 JohnMajor. All rights reserved.
//

import UIKit

class FavouriteImageViewController: UIViewController {

    @IBOutlet weak var favImageView: UIImageView!
    var givenURL:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        var error:NSError?
        if givenURL != nil {
            let imageData:NSData = NSData(contentsOfURL: NSURL(string: givenURL)!, options: nil, error: &error)!
            if error == nil{
                let image:UIImage = UIImage(data: imageData)!
                favImageView.image = image
            }
        }

    }
}
