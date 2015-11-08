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
    
    @IBOutlet weak var loginUsername: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(sender: UIButton) {
        
        let username = self.loginUsername.text
        let password = self.loginPassword.text
        
        // Validate the text fields
        // Run a spinner to show a task in progress
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
        spinner.startAnimating()
        
        // Send a request to login
        PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user, error) -> Void in
            
            // Stop the spinner
            spinner.stopAnimating()
            
            if ((user) != nil) {
                let verified: Bool = user!["emailVerified"] as! Bool
                if (verified==false){
                    
                    let emailAlertController = UIAlertController(title: "email not verified", message: "please verify the email address: " + (user?.email)!, preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }

                    emailAlertController.addAction(OKAction)
                    
                    self.presentViewController(emailAlertController, animated: true) {}
                    
                } else{
                    
                    let successAlertController = UIAlertController(title: "Success", message: "Logged In", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ContainerViewController")
                            self.presentViewController(viewController, animated: true, completion: nil)
                        })
                    }

                    successAlertController.addAction(OKAction)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.presentViewController(successAlertController, animated: true) {}
                    })                    
                }
                
            } else {
                
                let errorAlertController = UIAlertController(title: "Login error", message: "Username or password incorrect", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                errorAlertController.addAction(OKAction)
                
                self.presentViewController(errorAlertController, animated: true) {}
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
