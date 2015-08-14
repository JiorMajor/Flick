//
//  DetailsImageViewController.swift
//  Flick
//
//  Created by JohnMajor on 8/9/15.
//  Copyright (c) 2015 JohnMajor. All rights reserved.
//

import UIKit
import Social
import MediaPlayer

class DetailsImageViewController: UIViewController {

    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var detailsImageView: UIImageView!
    var givenURL:String!
    var text:String!
    var favouritePhotos: [AnyObject] = []
    var buttonPause = UIBarButtonItem()
    var buttonPlay = UIBarButtonItem()
    var Sqlite:SqliteHelper = SqliteHelper()
    var result:NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        buttonPause = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: "pauseAction")
        buttonPlay = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Play, target: self, action: "playAction")
        self.navigationItem.rightBarButtonItem = buttonPlay
        Sqlite.crateDatabase()
        result = Sqlite.findFavPhoto(givenURL)
        println("View did load \(givenURL)")
        var error:NSError?
        if givenURL != nil && text != nil {
            let imageData:NSData = NSData(contentsOfURL: NSURL(string: givenURL)!, options: nil, error: &error)!
            if error == nil{
                let image:UIImage = UIImage(data: imageData)!
                detailsImageView.image = image
                titleText.text = Sqlite.urltitle
                
            }
            var index:Int = 0
            for index = 0; index < Sqlite.titleList.count; ++index {
                if titleText.text == Sqlite.titleList[index] {
                    btnFavourite.backgroundColor = UIColor.redColor()
                    titleText.text = text
                }
            }
        }
        }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        var error:NSError?
        if givenURL != nil && text != nil {
            let imageData:NSData = NSData(contentsOfURL: NSURL(string: givenURL)!, options: nil, error: &error)!
            if error == nil{
                let image:UIImage = UIImage(data: imageData)!
                detailsImageView.image = image
                titleText.text = text
                
            }
            var index:Int = 0
            for index = 0; index < Sqlite.titleList.count; ++index {
                if titleText.text == Sqlite.titleList[index] {
                    btnFavourite.backgroundColor = UIColor.redColor()
                    titleText.text = Sqlite.selectNameFav(givenURL)
                    //Sqlite.deletFavPhoto(givenURL)
                }
            }
        }
    }
    
    func pauseAction() {
        self.navigationItem.rightBarButtonItem = buttonPlay
        pause()
       
    }
    
    func playAction() {
        self.navigationItem.rightBarButtonItem = buttonPause
         play()
    }

    var pauseSong:Bool = false
    
    func play(){
        let mediaItems = MPMediaQuery.songsQuery().items
        var query = MPMediaQuery.songsQuery()
        let mediaCollection = MPMediaItemCollection(items: mediaItems)
        let player = MPMusicPlayerController.applicationMusicPlayer()
        if pauseSong{
            player.play()
        }
        else{
        player.setQueueWithItemCollection(mediaCollection)
        player.shuffleMode = MPMusicShuffleMode.Songs
        player.play()
        }
    }
    
    func pause(){
        //let mediaItems = MPMediaQuery.songsQuery().items
        //let mediaCollection = MPMediaItemCollection(items: mediaItems)
        let player = MPMusicPlayerController.applicationMusicPlayer()
        //player.setQueueWithItemCollection(mediaCollection)
        player.pause()
        pauseSong = true
    }

    @IBAction func addToFavourite(sender: AnyObject) {
        if titleText.text == result.valueForKey("Title") as? String {
            btnFavourite.backgroundColor = UIColor.clearColor()
                Sqlite.deletFavPhoto(givenURL)
        }
        else{
    var result:NSDictionary = Sqlite.findFavPhoto(givenURL)
    if result.valueForKey("Title") == nil {
            btnFavourite.backgroundColor = UIColor.redColor()
            Sqlite.createFavPhoto(titleText.text!, url: givenURL, comment: "SomeComment", size: "s")
    }
        }

    }
    
    @IBAction func moreAction(sender: AnyObject) {

        let optionMenu = UIAlertController(title: nil, message: "Choose Share Option", preferredStyle: .ActionSheet)
        
        //Facebook
        let facebookAction = UIAlertAction(title: "Share to Facebook", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            if (SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)) {
                
                var controller = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                controller.setInitialText(self.titleText.text)
                controller.addImage(self.detailsImageView.image)
                
                self.presentViewController(controller, animated:true, completion:nil);
                
            } else {
                // 3
                println("no Facebook account found on device")
            }

        })
        
        //Twitter
        let tweetAction = UIAlertAction(title: "Tweet", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            if(SLComposeViewController.isAvailableForServiceType(  SLServiceTypeTwitter)) {
                var controller = SLComposeViewController(         forServiceType: SLServiceTypeTwitter)
                
                if (SLComposeViewController.isAvailableForServiceType(      SLServiceTypeTwitter)) {
                    controller.setInitialText(        self.titleText.text);
                    controller.addImage(self.detailsImageView.image )
                    
                    self.presentViewController(controller,          animated:true, completion:nil);
                }
            } else {
                println("no twitter account found on device")
            }

        })
        
        //Share
        let shareAction = UIAlertAction(title: "Share", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            var image:UIImage = self.detailsImageView.image!
            let activityItem = image
            let activityViewController = UIActivityViewController(
                activityItems: [activityItem], applicationActivities: nil)
            
            activityViewController.excludedActivityTypes = [
                UIActivityTypePostToWeibo,
                UIActivityTypePrint,
                UIActivityTypeAssignToContact,
                UIActivityTypeAddToReadingList,
                UIActivityTypePostToVimeo,
                UIActivityTypePostToTencentWeibo
            ]
            
            self.presentViewController(activityViewController, animated: true, completion: nil)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Cancelled")
        })

        optionMenu.addAction(facebookAction)
        optionMenu.addAction(tweetAction)
        optionMenu.addAction(shareAction)
        optionMenu.addAction(cancelAction)
        

        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CommentSegue" {
            let destinationViewController:CommentViewController = segue.destinationViewController as! CommentViewController
            var parseURL = givenURL
            println(parseURL)
            destinationViewController.givenURL = parseURL
        }
    }

    //end

}
