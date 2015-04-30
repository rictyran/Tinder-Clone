//
//  SignUpViewController.swift
//  Tinder Clone
//
//  Created by Richard Tyran on 4/30/15.
//  Copyright (c) 2015 Richard Tyran. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    
    
    @IBOutlet var genderSwitch: UISwitch!
    
    @IBOutlet var profilePic: UIImageView!
    
    @IBAction func signUp(sender: AnyObject) {
        
          var user = PFUser.currentUser()
        
        if genderSwitch.on {
            
            user["interestedIn"] = "female"
            
        } else {
            
            user["interestedIn"] = "male"
        }
        
        user.save()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        var user = PFUser.currentUser()
        
        // retrieve profile image from facebook account:
        
        var FBSession = PFFacebookUtils.session()
        
        var accessToken = FBSession.accessTokenData.accessToken
        
        let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token"+accessToken)
        
        let urlRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            let image = UIImage(data: data)
            
            self.profilePic.image = image
            
            
            
            user["image"] = data
            
            user.save()
        
            FBRequestConnection.startForMeWithCompletionHandler({ (connection, result, error) -> Void in
                
                user["gender"] = result["gender"]
                user["name"] = result["name"]
                
                user.save()
                
                println(result)
                
            })
            
        }
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
