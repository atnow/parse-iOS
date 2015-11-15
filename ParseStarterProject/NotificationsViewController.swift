//
//  NotificationsViewController.swift
//  atnow-iOS
//
//  Created by Ben Ribovich on 11/14/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class NotificationsViewController: PFQueryTableViewController  {

    var notifications: NSMutableArray?
    
    override func viewDidLoad() {
        let query = PFUser.query()
        query?.whereKey("objectId", equalTo: PFUser.currentUser()!.objectId!)
        query?.includeKey("notifications")
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if (error == nil){
                
                let user = objects?[0] as! PFUser
                self.notifications = user.objectForKey("notifications") as? NSMutableArray
                
            }
        })
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (notifications?.count)!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        if let descriptionLabel = cell.viewWithTag(201) as? UILabel {
            
            let notification = notifications![indexPath.row]
            let description = notification["type"]
            descriptionLabel.text = "\(description)"
        }

        
        return cell
    }
    
    
}
