//
//  FlickrPhoto.swift
//  Flick
//
//  Created by JohnMajor on 8/9/15.
//  Copyright (c) 2015 JohnMajor. All rights reserved.
//

import UIKit

class FlickrPhoto: NSObject {
   
    var thumbnail:UIImage!
    var largeImage:UIImage!
    
    var photoID:String!
    var farm:Int!
    var server:String!
    var secret:String!
    var title:String!
    
    override init() {
        super.init()
    }
    
}
