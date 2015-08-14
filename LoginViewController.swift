//
//  LoginViewController.swift
//  Flick
//
//  Created by JohnMajor on 8/13/15.
//  Copyright (c) 2015 JohnMajor. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnLogin(sender: AnyObject) {
        authenticateUser()
    }
    
    func authenticateUser() {
        let context: LAContext = LAContext()
        var error:NSError?
        var reasonString = "Authentication is required to access Flick Application"
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            context .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                if success {
                    println("touch id working")
                    self.performSegueWithIdentifier("TouchIDCorrect", sender: self)
                }
                else{
                    // If authentication failed then show a message to the console with a short description.
                    // In case that the error is a user fallback, then show the password alert view.
                    println(evalPolicyError?.localizedDescription)
                    
                    switch evalPolicyError!.code {
                        
                    case LAError.SystemCancel.rawValue:
                        println("Authentication was cancelled by the system")
                        
                    case LAError.UserCancel.rawValue:
                        println("Authentication was cancelled by the user")
                        
                    case LAError.UserFallback.rawValue:
                        println("User selected to enter custom password")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                        
                    default:
                        println("Authentication failed")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                    }
                }
            })
//             else {
//                
//                switch error!.code() {
//                    
//                case LAError.TouchIDNotEnrolled.toRaw():
//                    println("TouchID is not enrolled")
//                    break
//                    
//                case LAError.PasscodeNotSet.toRaw():
//                    println("A passcode has not been set")
//                    break
//                    
//                default:
//                    // The LAError.TouchIDNotAvailable case.
//                    println("TouchID not available")
//                    break
//                }
//                
//                // Optionally the error description can be displayed on the console.
//                println(error?.localizedDescription)
//                
//                // Show the custom alert view to allow users to enter the password.
//                self.showPasswordAlert()
//            }
        }

    }
    
    
    func showPasswordAlert() {
        var passwordAlert : UIAlertView = UIAlertView(title: "TouchID", message: "Please type your device passcode", delegate: self, cancelButtonTitle: "Cancel")
        passwordAlert.alertViewStyle = UIAlertViewStyle.SecureTextInput
        passwordAlert.show()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TouchIDCorrect" {
            let destinationViewController: UITabBarController = segue.destinationViewController as! UITabBarController
        }
    }

}
