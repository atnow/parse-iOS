//
//  SettingsTableViewController.swift
//  atnow-iOS
//
//  Created by Ben Ribovich on 2/29/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class SettingsTableViewController: MenuItemTableViewController {
    
    @IBOutlet weak var signOutCell: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        signOutCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "signout"))
    }
    
    func signout(){
        PFUser.logOut()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    
}