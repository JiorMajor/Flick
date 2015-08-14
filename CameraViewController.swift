//
//  CameraViewController.swift
//  Flick
//
//  Created by JohnMajor on 8/12/15.
//  Copyright (c) 2015 JohnMajor. All rights reserved.
//

import UIKit
import Social
import MessageUI

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var detailsImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        camera()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //camera()
    }
    
    func camera() {
        var imagePicker = UIImagePickerController()
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true,completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let activityItem  = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.dismissViewControllerAnimated(true,completion: nil)
        detailsImageView.image = activityItem
    }
    
    @IBAction func moreAction(sender: AnyObject) {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Share Option", preferredStyle: .ActionSheet)
        
        //Facebook
        let facebookAction = UIAlertAction(title: "Share to Facebook", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            if (SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook)) {
                
                var controller = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                
                controller.setInitialText("upload to Facebook")
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
                    controller.setInitialText(        "upload to Twitter");
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
        
        //Cancel
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


}
