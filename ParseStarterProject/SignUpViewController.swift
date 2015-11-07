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
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBAction func onSignUp(sender: UIButton) {
        let fullNameText  = self.fullNameField.text
        let emailText = self.emailField.text
        let usernameText = self.usernameField.text
        let passwordText = self.passwordField.text
        let confirmPasswordText = self.confirmPasswordField.text
        
        if usernameText?.characters.count < 5 {
            let alert = UIAlertView(title: "Invalid", message: "Username must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if passwordText?.characters.count < 8 {
            let alert = UIAlertView(title: "Invalid", message: "Password must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if passwordText! != confirmPasswordText!{
            let alert = UIAlertView(title: "Invalid", message: "Passwords do not match", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else{
        
        var newUser = PFUser()
        newUser.username = usernameText
        newUser.email = emailText! + "@dartmouth.edu"
        newUser.password = passwordText
        newUser["fullName"] = fullNameText
        
        // Sign up the user asynchronously
        newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
            
            // Stop the spinner
            if ((error) != nil) {
                let alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                
            } else {
                let alert = UIAlertView(title: "Success", message: "Signed Up! Please verify email.", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                    self.presentViewController(viewController, animated: true, completion: nil)
                })
            }
        })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
