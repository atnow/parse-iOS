//
//  ProfileViewController.swift
//  atnow-iOS
//
//  Created by Ben Ribovich on 11/7/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var userFullNameLabel: UILabel!
    
    @IBOutlet weak var starRatings: FloatRatingView!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    let designHelper = DesignHelper()
    
    let imagePicker = UIImagePickerController()
    
    var user : PFUser? = PFUser()
    
    var fromMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(fromMenu){
            self.navigationController?.navigationBarHidden = false
            let homeButton = UIBarButtonItem(image: UIImage(named:"reveal-icon"), style: UIBarButtonItemStyle.Plain, target: self, action: "showMenu:")
            self.navigationItem.leftBarButtonItem = homeButton
            self.navigationItem.title = self.title
        }
        
        imagePicker.delegate = self
        PFUser.currentUser()?.fetchInBackgroundWithBlock({ (response, error) -> Void in })
        if user?.username==nil{
            user = PFUser.currentUser()
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
        designHelper.formatButton(editButton)
        designHelper.formatPicture(profilePicture)
        
    }
    
    @IBAction func editProfile(sender: AnyObject) {
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
