//
//  RequestedTasksTableViewController.swift
//  atnow-iOS
//
//  Created by Benjamin Holland on 2/2/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Venmo_iOS_SDK


class RequestedTasksTableViewController: HomeViewController {
    
    var currentTab = 0
    var query : PFQuery?
    
    override func queryForTable() -> PFQuery {
        return self.query!
    }
    
    override func viewDidLoad(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:", name: "tabSelected", object: nil)
        self.query = PFQuery(className: "Task")
        self.query!.whereKey("requester", equalTo: PFUser.currentUser()!)
        self.query!.whereKey("expiration", greaterThan: NSDate())
        self.query!.whereKey("accepted", equalTo: false)
        
        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        if self.objects!.count == 0 {
            self.query!.cachePolicy = .CacheThenNetwork
        }
        
        self.query!.orderByDescending("expiration")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if(self.objects?.count != 0){
            tableView.backgroundView = nil
            return 1;
            
        }
        else{
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
            
            switch currentTab {
            case 0:
                noDataLabel.text = "No unclaimed tasks"
            case 1:
                noDataLabel.text = "No tasks in-progress"
            case 2:
                noDataLabel.text = "No tasks awaiting your confirmation"
            case 3:
                noDataLabel.text = "No complete tasks"
            default:
                break
            }
            
            noDataLabel.textAlignment = NSTextAlignment.Center
            noDataLabel.font = UIFont.systemFontOfSize(20)
            noDataLabel.textColor = UIColor.grayColor()
            tableView.backgroundView = noDataLabel
            
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            return 0;
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "requestedTaskDetail") {
            let svc = segue.destinationViewController as! ConfirmationViewController;
            let selectedIndex = self.tableView.indexPathForCell(sender as! PFTableViewCell)
            svc.selectedTask = self.objectAtIndexPath(selectedIndex)! as PFObject
        }
    }
    
    func loadList(notification: NSNotification){
        let userInfo = notification.userInfo! as NSDictionary
        currentTab = userInfo["number"] as! Int
        self.query = PFQuery(className: "Task")
        self.query!.whereKey("requester", equalTo: PFUser.currentUser()!)

        switch currentTab {
            case 0:
                self.query!.whereKey("accepted", equalTo: false)
                self.query!.whereKey("expiration", greaterThan: NSDate())
            case 1:
                self.query!.whereKey("accepted", equalTo: true)
                self.query!.whereKey("completed", equalTo: false)
                self.query!.whereKey("expiration", greaterThan: NSDate())
            case 2:
                self.query!.whereKey("completed", equalTo: true)
                self.query!.whereKey("confirmed", equalTo: false)
                self.query!.whereKey("expiration", greaterThan: NSDate())
            case 3:
                self.query!.whereKey("confirmed", equalTo: true)
            default:
             break
        }
        self.loadObjects()
    }    
}
