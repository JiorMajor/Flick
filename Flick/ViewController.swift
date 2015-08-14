//
//  ViewController.swift
//  Flick
//
//  Created by JohnMajor on 8/9/15.
//  Copyright (c) 2015 JohnMajor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var image: UIImageView!
    
    var step:Int = 0
    let Sqlite:SqliteHelper = SqliteHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //searchBar.becomeFirstResponder()
        searchBar.delegate = self
        Sqlite.crateDatabase()
        Sqlite.deleteAllCommentRows()
        Sqlite.deleteAllRows()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        performSegueWithIdentifier("Search", sender: self)
    }
    
    

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveEaseInOut, animations: {() -> Void in
            if self.step == 0 {
                self.image.transform = CGAffineTransformMakeScale(1.09, 1.09)
                self.step = 1
            }
            else{
                self.image.transform = CGAffineTransformIdentity
                self.step = 0
            }
            },completion: nil)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Search" {
        let destinationViewController:GalleryViewController = segue.destinationViewController as! GalleryViewController
        if !searchBar.text.isEmpty {
            destinationViewController.searchTerm = searchBar.text
        }
        else{
            let alert:UIAlertController = UIAlertController(title: "Oops", message: "Please enter a search keyword", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction (title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}



}

