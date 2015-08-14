//
//  GalleryViewController.swift
//  Flick
//
//  Created by JohnMajor on 8/9/15.
//  Copyright (c) 2015 JohnMajor. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {

    var searchTerm:String!
    var selectedURL:String!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var flickrResults:NSMutableArray! = NSMutableArray()
    var photoArray:NSMutableArray! = NSMutableArray()
    var titleArray:NSMutableArray! = NSMutableArray()
    let flickr:FlickrHelper = FlickrHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        loadPhotos()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPhotos(){
        flickr.searchFlickrForString(searchTerm, completion: { (searchString:String!, flickrPhotos:NSMutableArray!, error:NSError!) -> () in
            if error == nil{
                dispatch_async(dispatch_get_main_queue(), {
                    self.flickrResults = NSMutableArray(array: flickrPhotos)
                    println("flickResuls=====================>\(self.flickrResults)")
                    self.photoArray = self.flickr.FlickPhotoArray
                    self.titleArray = self.flickr.getFlickrPhotoTitle()
                    println("titleArray===========>\(self.titleArray)")
                    println("photoArray===========>\(self.photoArray)")
                    self.collectionView.reloadData()
                })
            }
            
        })
        
    }
    
    func loadRecentPhotos(){
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrResults.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:FlickrImageCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("FlickrCell", forIndexPath: indexPath) as! FlickrImageCollectionViewCell
        cell.image = nil
        let queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue, { () -> Void in
            var error:NSError?
            let searchURL:String = self.flickrResults.objectAtIndex(indexPath.item) as! String
            let imageData:NSData = NSData(contentsOfURL: NSURL(string: searchURL)!, options: nil, error: &error)!
            let title:String = self.titleArray.objectAtIndex(indexPath.item) as! String
            if error == nil{
                let image:UIImage = UIImage(data: imageData)!
                dispatch_async(dispatch_get_main_queue(), {
                    cell.image = image
                    cell.labelTitle.text = title
                    let yOffset:CGFloat = ((collectionView.contentOffset.y - cell.frame.origin.y) / 200) * 25
                    cell.imageOffset = CGPointMake(0, yOffset)
                    
                })
                
            }
            
        })
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        for view in collectionView.visibleCells(){
            var view:FlickrImageCollectionViewCell = view as! FlickrImageCollectionViewCell
            let yOffset:CGFloat = ((collectionView.contentOffset.y - view.frame.origin.y) / 200) * 25
            
            view.setImageOffset(CGPointMake(0, yOffset))
        
    }
}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectedURLsegue" {
            let destinationViewController:DetailsImageViewController = segue.destinationViewController as! DetailsImageViewController
            let cell = sender as! FlickrImageCollectionViewCell
            let indexPath = collectionView.indexPathForCell(cell)
            let searchURL = self.flickrResults.objectAtIndex(indexPath!.item) as! String
            let title = self.titleArray.objectAtIndex(indexPath!.item) as! String
            selectedURL = searchURL
            destinationViewController.givenURL = selectedURL
            destinationViewController.text = title
        }
    }
    
}

