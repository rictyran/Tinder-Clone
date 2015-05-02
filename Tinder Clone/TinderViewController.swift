//
//  TinderViewController.swift
//  Tinder Clone
//
//  Created by Richard Tyran on 4/30/15.
//  Copyright (c) 2015 Richard Tyran. All rights reserved.
//

import UIKit

class TinderViewController: UIViewController {

    var xFromCenter: CGFloat = 0
    
    var usernames = [String]()
    var userImages = [NSData]()
    var currentUser = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint: PFGeoPoint!, error: NSError!) -> Void in
            
            if error == nil {
                
                println(geopoint)
                
                var user = PFUser.currentUser()
                
                user["location"] = geopoint
                
                var query = PFUser.query()
                query.whereKey("location", nearGeoPoint:geopoint)
                
                query.limit = 10
                query.findObjectsInBackgroundWithBlock({ (users, error) -> Void in
                    
                    var accepted = [String]()
                
                    if PFUser.currentUser()["accepted"] != nil {
                        
                            accepted = PFUser.currentUser()["accepted"] as [String]
                        
                    }
                    
                    var rejected = [String]()
                    
                    if PFUser.currentUser()["rejected"] != nil {
                        
                        rejected = PFUser.currentUser()["rejected"] as [String]
                    
                    }
                    
                    for user in users {
                        
                        var gender1 = user["gender"] as? NSString
                        var gender2 = PFUser.currentUser()["interestedIn"] as? NSString
                        
                        if gender1 == gender2 && PFUser.currentUser().username != user.username && !contains(accepted, user.username) && !contains(rejected, user.username) {

                            self.usernames.append(user.username)
                            self.userImages.append(user["image"] as NSData)
                            
                        }
                        
                    }
                    
                    var userImage: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                    userImage.image = UIImage(data: self.userImages[0])
                    userImage.contentMode = UIViewContentMode.ScaleAspectFit
                    self.view.addSubview(userImage)
                    
                    var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
                    userImage.addGestureRecognizer(gesture)
                    
                    userImage.userInteractionEnabled = true
                
                })
                
                user.save()
                
            }
        }
    
    }
        
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        var label = gesture.view!
        
        xFromCenter += translation.x
        
        var scale = min(100 / abs(xFromCenter), 1)
        
        label.center = CGPoint(x: label.center.x + translation.x, y: label.center.y + translation.y)
        
        gesture.setTranslation(CGPointZero, inView: self.view)
        
        var rotation:CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter / 200)
        
        var stretch:CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
        
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            if label.center.x < 100 {
                
                println("Not Chosen")
                
                PFUser.currentUser().addUniqueObject(self.usernames[self.currentUser], forKey: "rejected")
                PFUser.currentUser().save()
                
                 self.currentUser++
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                println("Chosen")
                
                PFUser.currentUser().addUniqueObject(self.usernames[self.currentUser], forKey: "accepted")
                PFUser.currentUser().save()
                
                 self.currentUser++
                
            }
            
            label.removeFromSuperview()
            
            if self.currentUser < self.userImages.count {
            
            var userImage: UIImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
            userImage.image = UIImage(data: self.userImages[self.currentUser])
            userImage.contentMode = UIViewContentMode.ScaleAspectFit
            self.view.addSubview(userImage)
            
            var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
            userImage.addGestureRecognizer(gesture)
            
            userImage.userInteractionEnabled = true
            
            xFromCenter = 0
            
            } else {
                
                println("No more users")
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
    }
}


//        var i = 20
//
//        func addPerson(urlString:String) {
//
//            var newUser = PFUser()
//
//            let url = NSURL(string: urlString)
//
//            let urlRequest = NSURLRequest(URL: url!)
//
//            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
//
//                newUser["image"] = data
//
//                newUser["gender"] = "female"
//
//                var lat = Double(37 + i)
//
//                var lon = Double(-122 + i)
//
//                i = i + 10
//
//                var location = PFGeoPoint(latitude: lat, longitude: lon)
//
//                newUser["location"] = location
//
//                newUser.username = "\(i)"
//
//                newUser.password = "password"
//
//                newUser.signUp()
//            }
//
//        }

//            addPerson("http://www.polyvore.com/cgi/img-thing?.out=jpg&size=l&tid=44643840")
//            addPerson("http://static.comicvine.com/uploads/square_small/0/2617/103863-63963-torongo-leela.JPG")
//            addPerson("http://i263.photobucket.com/albums/ii139/whatgloom/janejetson.jpg")
//            addPerson("http://www.scrapwallpaper.com/wp-content/uploads/2014/08/female-cartoon-characters-pictures-6.jpg")
//            addPerson("http://diaryofalagosmumblog.files.wordpress.com/2011/11/smurfette-scaled500.gif")