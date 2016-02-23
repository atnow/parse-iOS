//
//  LoginViewController.swift
//  now
//
//  Created by Benjamin Holland on 11/3/15.
//  Copyright © 2015 Ben Ribovich. All rights reserved.
//

import UIKit
import Parse
import Venmo_iOS_SDK

class LoginViewController: UIViewController{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    
    @IBOutlet weak var singUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    let designHelper = DesignHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = designHelper.baseColor
        designHelper.formatButton(singUpButton)
        designHelper.formatButton(loginButton)
        loginEmail.layer.borderColor = UIColor.whiteColor().CGColor
        loginEmail.layer.borderWidth = 1
        loginEmail.layer.cornerRadius = 4
        loginPassword.layer.borderColor = UIColor.whiteColor().CGColor
        loginPassword.layer.borderWidth = 1
        loginPassword.layer.cornerRadius = 4
        titleLabel.textColor = UIColor.whiteColor()
        singUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        singUpButton.layer.backgroundColor = UIColor.clearColor().CGColor
        singUpButton.layer.borderColor = UIColor.clearColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(sender: UIButton) {
        
        let email = self.loginEmail.text
        let password = self.loginPassword.text
        
        // Validate the text fields
        // Run a spinner to show a task in progress
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
        spinner.startAnimating()
        
        
        // Send a request to login
        PFUser.logInWithUsernameInBackground(email!, password: password!, block: { (user, error) -> Void in
            spinner.stopAnimating()
            if ((user) != nil) {
                let verified: Bool = user!["emailVerified"] as! Bool
                if (verified==false){
                    PFUser.logOut()
                    let emailAlertController = UIAlertController(title: "email not verified", message: "please verify the email address: " + (user!["email"] as! String), preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                    
                    emailAlertController.addAction(OKAction)
                    
                    self.presentViewController(emailAlertController, animated: true) {}
                    
                }
                
                //Venmo Check
                if(!Venmo.sharedInstance().isSessionValid() || Venmo.sharedInstance().session.user==nil || user!["phoneNumber"]==nil || (Venmo.sharedInstance().session.user.primaryPhone != (user!["phoneNumber"] as! String))){
                    //Alert saying @now needs Venmo
                    
                    
                    let venmoAuthAlert = UIAlertController(title: "Venmo Authorization", message: "@now requires users to link their venmo in order to process payments", preferredStyle: .Alert)
                    
                    let authAction = UIAlertAction(title: "Authorize", style: .Default) { (action) in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.navigationController?.popViewControllerAnimated(true)
                            
                            // Venmo Auth Flow
                            Venmo.sharedInstance().requestPermissions(["make_payments", "access_profile", "access_phone"]) { (success, error) -> Void in
                                if (success){
                                    let successAlertController = UIAlertController(title: "Success!", message: "All future transactions will go through venmo", preferredStyle: .Alert)
                                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            self.navigationController?.popViewControllerAnimated(true)
                                            
//                                            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ContainerViewController")
//                                            self.presentViewController(viewController, animated: true, completion: nil)
//                                            let installation = PFInstallation.currentInstallation()
//                                            installation["user"] = PFUser.currentUser()
//                                            installation.saveInBackground()

                                            
                                        })
                                    }
                                    successAlertController.addAction(OKAction)
                                    
                                    // Save venmo information in Parse
                                    
                                    user!["phoneNumber"] = Venmo.sharedInstance().session.user.primaryPhone
                                    user!["venmoAccessToken"] = Venmo.sharedInstance().session.accessToken
                                    user!.saveInBackground()
                                    
                                    self.presentViewController(successAlertController, animated: true) {}
                                }
                                else{
                                    let errorAlertController = UIAlertController(title: "Oops!", message: "Something went wrong while authorizing venmo. Please try again later.", preferredStyle: .Alert)
                                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            PFUser.logOut()
                                            self.navigationController?.popViewControllerAnimated(true)
                                        })
                                    }
                                    errorAlertController.addAction(OKAction)
                                    self.presentViewController(errorAlertController, animated: true) {}
                                }
                            }
                        })
                    }
                    
                    let logoutAction = UIAlertAction(title: "Logout", style: .Default) { (action) in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            PFUser.logOut()
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                    }
                    
                    venmoAuthAlert.addAction(authAction)
                    venmoAuthAlert.addAction(logoutAction)
                    
                    self.presentViewController(venmoAuthAlert, animated: true) {}
                    
                }
                
                

                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ContainerViewController")
                self.presentViewController(viewController, animated: true, completion: nil)
                let installation = PFInstallation.currentInstallation()
                installation["user"] = PFUser.currentUser()
                installation.saveInBackground()

                
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
