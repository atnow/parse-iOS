//
//  MyTasksViewController.swift
//  atnow-iOS
//
//  Created by Benjamin Holland on 11/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class MyTasksViewController: HomeViewController {
    
    
    var currentTab = 0
    var query : PFQuery?

      override func queryForTable() -> PFQuery {
        return self.query!
    }
    
    override func viewDidLoad(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:", name: "myTasksTabSelected", object: nil)
        
        let acceptorQuery = PFQuery(className: "Task")
        acceptorQuery.whereKey("accepter", equalTo: PFUser.currentUser()!)
        acceptorQuery.whereKey("expiration", greaterThan: NSDate())
        
        
        self.query = acceptorQuery
        
        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        if self.objects!.count == 0 {
            self.query!.cachePolicy = .CacheThenNetwork
        }
        
        self.query!.orderByDescending("expiration")
        self.query!.whereKey("accepted", equalTo: true)
        self.query!.whereKey("completed", equalTo: false)
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
                noDataLabel.text = "You don't have any tasks to-do"
            case 1:
                noDataLabel.text = "No tasks are awaiting confirmation"
            case 2:
                noDataLabel.text = "You haven't completed any tasks"
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
    
    func loadList(notification: NSNotification){
        let userInfo = notification.userInfo! as NSDictionary
        currentTab = userInfo["number"] as! Int
        self.query = PFQuery(className: "Task")
        self.query!.whereKey("accepter", equalTo: PFUser.currentUser()!)

        switch currentTab {
        case 0:
            self.query!.whereKey("accepted", equalTo: true)
            self.query!.whereKey("completed", equalTo: false)
            self.query!.whereKey("expiration", greaterThan: NSDate())
        case 1:
            self.query!.whereKey("completed", equalTo: true)
            self.query!.whereKey("confirmed", equalTo: false)
            self.query!.whereKey("expiration", greaterThan: NSDate())
        case 2:
            self.query!.whereKey("confirmed", equalTo: true)
        default:
            break
        }
        self.loadObjects()
        
    }

}
