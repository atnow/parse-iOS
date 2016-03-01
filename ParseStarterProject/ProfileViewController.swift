//
//  ProfileViewController.swift
//  atnow-iOS
//
//  Created by Ben Ribovich on 11/7/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import Venmo_iOS_SDK

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var starRatings: FloatRatingView!
    
    @IBOutlet weak var phoneImageView: UIImageView!
    
    @IBOutlet weak var phoneNumberTextView: UITextView!
    let designHelper = DesignHelper()
    let imagePicker = UIImagePickerController()
    var user : PFUser? = PFUser()
    var fromMenu = false
    var isOwnProfile : Bool = false
    var feedViewController: ProfileFeedViewController?
    
    var menuVC:MenuViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(fromMenu){
            self.navigationController?.navigationBarHidden = false
            let homeButton = UIBarButtonItem(image: UIImage(named:"reveal-icon"), style: UIBarButtonItemStyle.Plain, target: self, action: "showMenu:")
            self.navigationItem.leftBarButtonItem = homeButton
            self.navigationItem.title = self.title
        }
        

     //   let settingsButton = UIBarButtonItem(barButtonSystemItem: , target: self, action: "displaySettings:")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        
        imagePicker.delegate = self
        if user?.username==nil || user?.username == PFUser.currentUser()?.username{
            user = PFUser.currentUser()
            isOwnProfile = true
        }
        
        let query = PFQuery(className: "_User")
        query.includeKey("rating")
        query.getObjectInBackgroundWithId((user?.objectId)!) { (result, error) -> Void in
            if error==nil{
                self.user = result as? PFUser
                if self.user?["rating"] != nil {
                    self.starRatings.rating = self.user!["rating"]["rating"] as! Float!
                    
                    self.userFullNameLabel.text = self.user!["fullName"] as! String!
                    
                    let imageFromParse = self.user!.objectForKey("profilePicture") as? PFFile
                    if(imageFromParse != nil){
                        imageFromParse!.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                            let image: UIImage! = UIImage(data: imageData!)!
                            self.profilePicture.image = image
                        })
                    }
                }

            } else{
                print(error)
            }
        }

        designHelper.formatPicture(profilePicture)
        profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "changeProfilePicture"))
        
        if(isOwnProfile){
            let settingsButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "displaySettings:")
            self.navigationItem.rightBarButtonItem = settingsButton
        }
        let phoneImage = UIImage(named: "phone-small")
        phoneImageView.image = phoneImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let s = self.user?["phone"] as! String
        let s2 = String(format: "(%@) %@-%@",
            s.substringWithRange(s.startIndex.advancedBy(1) ... s.startIndex.advancedBy(3)),
            s.substringWithRange(s.startIndex.advancedBy(4) ... s.startIndex.advancedBy(6)),
            s.substringWithRange(s.startIndex.advancedBy(7) ... s.startIndex.advancedBy(10))
        )
        phoneNumberTextView.text = s2
    }
    
    
    func changeProfilePicture() {
        if(isOwnProfile){
            let profileChangeMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            self.imagePicker.allowsEditing = true
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in }
            let takePictureAction = UIAlertAction(title: "Take new picture", style: .Default) { (action) in
                self.imagePicker.sourceType = .Camera
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            }
            
            let libraryPictureAction = UIAlertAction(title: "Choose picture", style: .Default) { (action) in
                self.imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            }
            
            profileChangeMenu.addAction(takePictureAction)
            profileChangeMenu.addAction(libraryPictureAction)
            profileChangeMenu.addAction(cancelAction)
            self.presentViewController(profileChangeMenu, animated: true, completion: nil)
        
        }

    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profilePicture.image = pickedImage
            designHelper.formatPicture(profilePicture)
            let imageData = UIImageJPEGRepresentation(pickedImage, 0.1)
            let imageFile = PFFile(name:"image.png", data: imageData!)
            self.user!["profilePicture"] = imageFile
            self.user?.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                if(succeeded == true){
                    self.menuVC?.profileImageView.image = pickedImage

                }
                else{
                    print(error)
                }
            })
        }
            
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func signOutAction(sender: AnyObject) {
        // Send a request to log out a user
        PFUser.logOut()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    
    func showMenu(sender: AnyObject){
        let CVC = self.navigationController?.parentViewController as! ContainerViewController
        CVC.showMenu()
        
    }
    func displaySettings(sender: AnyObject){
        PFUser.logOut()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="showFeed"){
            self.feedViewController = segue.destinationViewController as? ProfileFeedViewController

            if self.user?.username==nil || self.user?.username == PFUser.currentUser()?.username{
                    self.feedViewController?.user = PFUser.currentUser()
            } else{
                self.feedViewController?.user = self.user
            }
        }
    }
}
