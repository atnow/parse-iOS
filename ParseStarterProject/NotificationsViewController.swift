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
    
    override init(style: UITableViewStyle, className: String?) {
        super.init(style: style, className: className)
        parseClassName = "Notification"
        pullToRefreshEnabled = true
        paginationEnabled = true
        objectsPerPage = 25
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        parseClassName = "Notification"
        pullToRefreshEnabled = true
        paginationEnabled = true
        objectsPerPage = 25
    }
    
    var notifications: NSMutableArray?
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
        
        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        if self.objects!.count == 0 {
            query.cachePolicy = .CacheThenNetwork
        }
        
        query.whereKey("owner", equalTo: PFUser.currentUser()!)

        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        let cellIdentifier = "NotificationCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PFTableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "NotificationCell") as? PFTableViewCell
            
        }
        
        // Configure the cell to show todo item with a priority at the bottom
        if let object = object {
            //            cell!.textLabel?.text = object["title"] as? String
            //            let priority = object["priority"] as? String
            //            cell!.detailTextLabel?.text = "Priority \(priority)"
            

            
            
            if let descriptionLabel = cell!.viewWithTag(201) as? UILabel {
                let description : String
                let taskName = "\(object["task"]["title"])"
                let acceptName = "\(object["task"]["accepter"]!!["fullName"])"
                let requestName = "\(object["task"]["requester"]!!["fullName"])"
                
                switch object["type"] as! String{
                    
                case "claimed":
                    description = "Your task" + taskName + "was claimed by " + acceptName
                case "completed":
                    description = "Your task" + taskName + "was completed by " + acceptName
                case "confirmed":
                    description = requestName + " confirmed your completion of " + taskName
                default:
                    description = " "
                    
                    
                }
                descriptionLabel.text = "\(description)"
            }
            
            
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        let homeButton = UIBarButtonItem(image: UIImage(named:"reveal-icon"), style: UIBarButtonItemStyle.Plain, target: self, action: "showMenu:")
        self.navigationItem.leftBarButtonItem = homeButton
        self.navigationItem.title = self.title
        
    }
    
    func showMenu(sender: AnyObject){
        let CVC = self.navigationController?.parentViewController as! ContainerViewController
        CVC.showMenu()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
