//
//  SignUpViewController.swift
//  atnow-iOS
//
//  Created by Benjamin Holland on 11/7/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var fullNameIcon: UIImageView!
    let designHelper = DesignHelper()
    
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var confirmPasswordIcon: UIImageView!
    @IBOutlet weak var passwordIcon: UIImageView!
    
    @IBAction func onSignUp(sender: UIButton) {
        let fullNameText  = self.fullNameField.text
        let emailText = self.emailField.text
        let passwordText = self.passwordField.text
        let confirmPasswordText = self.confirmPasswordField.text
        
        let alertController = UIAlertController(title: "Invalid", message: "Username must be greater than 5 characters", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        
        alertController.addAction(OKAction)
        
        if passwordText?.characters.count < 8 {
            
            alertController.message = "Password must be greater than 8 characters"
            self.presentViewController(alertController, animated: true) {}
            
        } else if passwordText! != confirmPasswordText!{
            
            alertController.message = "Passwords do not match"
            self.presentViewController(alertController, animated: true) {}
            
        } else if (!emailText!.containsString("@dartmouth.edu")) {
            
            alertController.message = "Email address is not a dartmouth email address"
            self.presentViewController(alertController, animated: true) {}
            
        } else{
            
            let newUser = PFUser()
            newUser.username = emailText!
            newUser.email = emailText!
            newUser.password = passwordText
            newUser["fullName"] = fullNameText
            let rating = PFObject(className: "Rating")
            rating.ACL?.setPublicWriteAccess(true)
            rating["rating"] = 0
            rating["ratingCount"] = 0
            newUser["rating"] = rating
            
            
            // Sign up the user asynchronously
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                if ((error) != nil) {
                    let errorAlertController = UIAlertController(title: "Error", message: "\(error)",preferredStyle: .Alert)
                    errorAlertController.addAction(OKAction)
                    self.presentViewController(errorAlertController, animated: true) {}
                    
                } else {
                    let OKSignUpAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                            self.presentViewController(viewController, animated: true, completion: nil)
                        })
                    }
                    let successAlertController = UIAlertController(title: "Success", message: "Signed Up! Please verify email.",preferredStyle: .Alert)
                    successAlertController.addAction(OKSignUpAction)
                    self.presentViewController(successAlertController, animated: true) {}
                }
            })
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        designHelper.formatButton(signUpButton)
        designHelper.formatButton(cancelButton)

        fullNameField.layer.cornerRadius = 8
        fullNameField.layer.backgroundColor = designHelper.transparentWhite

        emailField.layer.cornerRadius = 8
        emailField.layer.backgroundColor = designHelper.transparentWhite

        passwordField.layer.cornerRadius = 8
        passwordField.layer.backgroundColor = designHelper.transparentWhite
        
        confirmPasswordField.layer.cornerRadius = 8
        confirmPasswordField.layer.backgroundColor = designHelper.transparentWhite
        
        
        let passwordImage = UIImage(named: "lock")
        let confirmPasswordImage = UIImage(named: "lock")
        let emailImage = UIImage(named: "email")
        let fullNameImage = UIImage(named: "name")
        
        passwordIcon.image = passwordImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        confirmPasswordIcon.image = confirmPasswordImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        fullNameIcon.image = fullNameImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        emailIcon.image = emailImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        passwordIcon.tintColor = UIColor.whiteColor()
        confirmPasswordIcon.tintColor = UIColor.whiteColor()
        fullNameIcon.tintColor = UIColor.whiteColor()
        emailIcon.tintColor = UIColor.whiteColor()
        
        passwordIcon.backgroundColor = UIColor.clearColor()
        confirmPasswordIcon.backgroundColor = UIColor.clearColor()
        fullNameIcon.backgroundColor = UIColor.clearColor()
        emailIcon.backgroundColor = UIColor.clearColor()
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
