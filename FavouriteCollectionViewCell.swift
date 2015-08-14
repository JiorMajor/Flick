//
//  FavouriteCollectionViewCell.swift
//  Flick
//
//  Created by JohnMajor on 8/10/15.
//  Copyright (c) 2015 JohnMajor. All rights reserved.
//

import UIKit

class FavouriteCollectionViewCell: UICollectionViewCell {
    
    var imageView:UIImageView!
    
    var image:UIImage!{
        get{
            return self.image
        }
        set {
            self.imageView.image = newValue
            if imageOffset != nil{
                setImageOffset(imageOffset)
            }else{
                setImageOffset(CGPointMake(0, 0))
            }
        }
    }
    
    var imageOffset:CGPoint!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setUpImageView()
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpImageView()
    }
    
    func setUpImageView(){
        
        self.clipsToBounds = true
        imageView = UIImageView(frame: CGRectMake(self.bounds.origin.x, self.bounds.origin.y, 320, 200))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        self.addSubview(imageView)
    }
    
    func setImageOffset(imageOffset:CGPoint){
        self.imageOffset = imageOffset
        let frame:CGRect = imageView.bounds
        let OffsetFrame:CGRect = CGRectOffset(frame, self.imageOffset.x, self.imageOffset.y)
        imageView.frame = OffsetFrame
    }
    
}
