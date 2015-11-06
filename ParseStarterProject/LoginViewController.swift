//
//  LoginViewController.swift
//  now
//
//  Created by Benjamin Holland on 11/3/15.
//  Copyright © 2015 Ben Ribovich. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController{
    
    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func onSignUp(sender: UIButton) {
        let fullNameText  = self.fullName.text
        let emailText = self.email.text
        let usernameText = self.username.text
        let passwordText = self.password.text
        let confirmPasswordText = self.confirmPassword.text
        
        if usernameText?.characters.count < 5 {
            let alert = UIAlertView(title: "Invalid", message: "Username must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if passwordText?.characters.count < 8 {
            let alert = UIAlertView(title: "Invalid", message: "Password must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        
        } else if passwordText! != confirmPasswordText!{
            let alert = UIAlertView(title: "Invalid", message: "Passwords do not match", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        
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
                let alert = UIAlertView(title: "Success", message: "Signed Up", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainNavigationController")
                    self.presentViewController(viewController, animated: true, completion: nil)
                })
            }
        })
        
        
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
