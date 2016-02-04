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
        
//        let acceptorQuery = PFQuery(className: "Task")
//        acceptorQuery.whereKey("accepter", equalTo: PFUser.currentUser()!)
//        
//        return acceptorQuery
        return self.query!
    }
    
    override func viewDidLoad(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:", name: "tabSelected", object: nil)
        let requesterQuery = PFQuery(className: "Task")
        requesterQuery.whereKey("requester", equalTo: PFUser.currentUser()!)
        
        self.query = requesterQuery
        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        if self.objects!.count == 0 {
            self.query!.cachePolicy = .CacheThenNetwork
        }
        
        self.query!.orderByDescending("expiration")
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.sectionHeaderHeight = 2
        let cellIdentifier = "MyTaskCell"
      
        // Configure the cell to show todo item with a priority at the bottom
        
            
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PFTableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "MyTaskCell") as? PFTableViewCell
        }
        
        if let object = object {
            if let descriptionLabel = cell!.viewWithTag(100) as? UILabel {
                let description = object["title"]
                descriptionLabel.text = "\(description)"
            }
            
            if let priceLabel = cell!.viewWithTag(101) as? UILabel {
                let price = object["price"]
                priceLabel.text = "$" + String(price)
                
            }
            if let expirationLabel = cell!.viewWithTag(102) as? UILabel {
                let exp = object["expiration"] as! NSDate
                let date = NSDate()
                let timeToExpire = Int(exp.timeIntervalSinceDate(date)/60)
                let days = "\(Int(timeToExpire/1440))" + "d "
                expirationLabel.text = days + "\(Int(timeToExpire%1440)/60)" + "h " + "\(timeToExpire%60)" + "m"
                if timeToExpire <= 0 {
                    expirationLabel.text = "Expired"
                }
                
            }
            
        }
        return cell
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
        switch currentTab {
            case 0:
                self.query!.whereKey("accepted", equalTo: false)
            case 1:
                self.query!.whereKey("accepted", equalTo: true)
                self.query!.whereKey("completed", equalTo: false)
            case 2:
                self.query!.whereKey("completed", equalTo: true)
                self.query!.whereKey("confirmed", equalTo: false)
            case 3:
                self.query!.whereKey("confirmed", equalTo: true)
            default:
             break
        }
        self.loadObjects()
        
    }
    
//    func findRequestedTaskState(task : PFObject) -> Int{
//        if((task["confirmed"] as! Bool) == true){
//            return 3
//        }
//        else if((task["completed"] as! Bool) == true){
//            return 2
//        }
//        else if((task["accepted"] as! Bool) == true){
//            return 1
//        }
//        else{
//            return 0
//        }
//        
//    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
