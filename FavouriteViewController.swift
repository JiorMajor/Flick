//
//  FavouriteViewController.swift
//  Flick
//
//  Created by JohnMajor on 8/10/15.
//  Copyright (c) 2015 JohnMajor. All rights reserved.
//

import UIKit

class FavouriteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    let Sqlite: SqliteHelper = SqliteHelper()
    var selectedURL:String!
    var searchUrl:String!
    var titleArray = [String]()
    var urlList = [String]()
    var titleText:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        println("Favourite view did load")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        loadPhoto()
        collectionView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        loadPhoto()
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPhoto() {
        Sqlite.crateDatabase()
        Sqlite.prepareStatement()
        println(Sqlite.selectAllFavPhotos())
        urlList = Sqlite.selectAllFavPhotos()
        self.titleArray = Sqlite.titleList
        println("loadPhoto =================> \(urlList.count)")
        //collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("============>wanted value \(self.urlList.count)")
        return self.urlList.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:FavouriteCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! FavouriteCollectionViewCell
        cell.image = nil
        var error:NSError?
        searchUrl = self.urlList[indexPath.item] as String
        titleText = self.titleArray[indexPath.item] as String
        let imageData:NSData = NSData(contentsOfURL: NSURL(string: searchUrl)!, options: nil, error: &error)!
        if error == nil{
            let image:UIImage = UIImage(data: imageData)!
            dispatch_async(dispatch_get_main_queue(), {
                cell.image = image
                let yOffset:CGFloat = ((collectionView.contentOffset.y - cell.frame.origin.y) / 200) * 25
                cell.imageOffset = CGPointMake(0, yOffset)
                
            })
            
        }
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        for view in collectionView.visibleCells(){
            var view:FavouriteCollectionViewCell = view as! FavouriteCollectionViewCell
            let yOffset:CGFloat = ((collectionView.contentOffset.y - view.frame.origin.y) / 200) * 25
            
            view.setImageOffset(CGPointMake(0, yOffset))
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectedFavPhoto" {
            let destinationViewController:DetailsImageViewController = segue.destinationViewController as! DetailsImageViewController
            let cell = sender as! FavouriteCollectionViewCell
            let indexPath = collectionView.indexPathForCell(cell)
            let searchURL = self.urlList[indexPath!.row] as String
            selectedURL = searchURL
            destinationViewController.givenURL = selectedURL
            destinationViewController.text = titleText
        }
    
    }
}
