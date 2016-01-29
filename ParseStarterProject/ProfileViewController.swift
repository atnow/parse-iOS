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
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var venmoSwitch: UISwitch!
    @IBOutlet weak var changePictureButton: UIButton!
    @IBOutlet weak var venmoLabel: UIImageView!
    
    let designHelper = DesignHelper()
    let imagePicker = UIImagePickerController()
    var user : PFUser? = PFUser()
    var fromMenu = false
    var isOwnProfile : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(fromMenu){
            self.navigationController?.navigationBarHidden = false
            let homeButton = UIBarButtonItem(image: UIImage(named:"reveal-icon"), style: UIBarButtonItemStyle.Plain, target: self, action: "showMenu:")
            self.navigationItem.leftBarButtonItem = homeButton
            self.navigationItem.title = self.title
        }
        


        let settingsButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "displaySettings:")
        
        self.navigationItem.rightBarButtonItem = settingsButton
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:
            UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()

        
        imagePicker.delegate = self
        PFUser.currentUser()?.fetchInBackgroundWithBlock({ (response, error) -> Void in })
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

        designHelper.formatButton(logoutButton)
        designHelper.formatPicture(profilePicture)
        
        if(!isOwnProfile){
            logoutButton.hidden = true
            venmoSwitch.hidden = true
            changePictureButton.hidden = true
            venmoLabel.hidden = true
        }
        
    }
    
    @IBAction func onSwitch(sender: UISwitch) {
        
        if(venmoSwitch.on) {
            //  Venmo permission requests
            //  Only happens if the user hasn't already authorized Venmo
            //if(!Venmo.sharedInstance().isSessionValid()){
                Venmo.sharedInstance().requestPermissions(["make_payments", "access_profile", "phone_number"]) { (success, error) -> Void in
                    if (success){
                        let successAlertController = UIAlertController(title: "Success!", message: "All future transactions will go through venmo", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.navigationController?.popViewControllerAnimated(true)
                            })
                        }
                        successAlertController.addAction(OKAction)
                        
                        // Save venmo information in Parse
                        
  //                      self.user!["venmoPhoneNumber"] = Venmo.sharedInstance().session.user.primaryPhone
                        self.user!["venmoAccessToken"] = Venmo.sharedInstance().session.accessToken
                        self.user!.saveInBackground()
                        
                        self.presentViewController(successAlertController, animated: true) {}
                    }
                    else{
                        let errorAlertController = UIAlertController(title: "Oops!", message: "Something went wrong while authorizing venmo. Please try again later.", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.navigationController?.popViewControllerAnimated(true)
                            })
                        }
                        errorAlertController.addAction(OKAction)
                        self.presentViewController(errorAlertController, animated: true) {}
                    }
                }
            //}
        }
    }

    
    @IBAction func changeProfilePicture(sender: UIButton) {
        let profileChangeMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        self.imagePicker.allowsEditing = false
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
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePicture.contentMode = .ScaleAspectFit
            profilePicture.image = pickedImage
            designHelper.formatPicture(profilePicture)
            let imageData = UIImageJPEGRepresentation(pickedImage, 0.1)
            let imageFile = PFFile(name:"image.png", data: imageData!)
            self.user!["profilePicture"] = imageFile
            
            self.user?.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                if(succeeded == true){
                    //
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
