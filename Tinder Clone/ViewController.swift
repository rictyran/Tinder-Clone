//
//  ViewController.swift
//  Tinder Clone
//
//  Created by Richard Tyran on 2/28/15.
//  Copyright (c) 2015 Richard Tyran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var signInCancelledLabel: UILabel!
    
    @IBAction func signIn(sender: AnyObject) {
        
        var permissions = ["public_profile"]
        
         self.signInCancelledLabel.alpha = 0
        
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                    
                    self.performSegueWithIdentifier("signUp", sender: self)
                    
                } else {
                    println("User logged in through Facebook!")
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
                
                self.signInCancelledLabel.alpha = 1
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        var push = PFPush()
//        push.setMessage("This is a test")
//        push.sendPushInBackgroundWithBlock({
//            (isSuccessful: Bool!, error: NSError!) -> Void in
//        
//            println(isSuccessful)
//            
//        })

        if PFUser.currentUser() != nil {
            
           println("User logged in")
            
            
        }
    
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

