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
    
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
        
        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        if self.objects!.count == 0 {
            query.cachePolicy = .CacheThenNetwork
        }
        
        query.whereKey("expiration", greaterThan: NSDate())
        query.whereKey("accepted", equalTo: false )
        query.orderByAscending("expiration")
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        let cellIdentifier = "TaskCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PFTableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "TaskCell") as? PFTableViewCell
            
            //cell = PFTableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        // Configure the cell to show todo item with a priority at the bottom
        if let object = object {
            //            cell!.textLabel?.text = object["title"] as? String
            //            let priority = object["priority"] as? String
            //            cell!.detailTextLabel?.text = "Priority \(priority)"
            
            
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
            }
            
            
        }
        
        return cell
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
