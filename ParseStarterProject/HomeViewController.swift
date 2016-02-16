//
//  HomeViewController.swift
//  now
//
//  Created by Ben Ribovich on 10/15/15.
//  Copyright © 2015 Ben Ribovich. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Venmo_iOS_SDK

class HomeViewController : PFQueryTableViewController {
    
    let designHelper = DesignHelper()
    var venmoAuthorized = false
    

    override init(style: UITableViewStyle, className: String?) {
        super.init(style: style, className: className)
        parseClassName = "Task"
        pullToRefreshEnabled = true
        paginationEnabled = true
        objectsPerPage = 25
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        parseClassName = "Task"
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
        }
        
        // Configure the cell to show todo item with a priority at the bottom
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
                if (timeToExpire <= 0) {
                    expirationLabel.text = "Expired"
                }
            }
            
            var tag = 201
            if((object["requiresCar"] != nil) && (object["requiresCar"] as! Bool)){
                let imageView = cell?.viewWithTag(tag) as! UIImageView
                imageView.image = UIImage(named: "car")
                tag++
            }
            if((object["requiresLifting"] != nil) && (object["requiresLifting"] as! Bool)){
                let imageView = cell?.viewWithTag(tag) as! UIImageView
                imageView.image = UIImage(named: "credit-card")
                tag++
            }
            if((object["requiresPurchase"] != nil) && (object["requiresPurchase"] as! Bool)){
                let imageView = cell?.viewWithTag(tag) as! UIImageView
                imageView.image = UIImage(named: "heavy-lifting")
            }
            
        }
        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if(self.objects?.count != 0){
            tableView.backgroundView = nil
            return 1;
            
        }
        else{
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
            noDataLabel.text = "No tasks are available at this time"
            noDataLabel.textAlignment = NSTextAlignment.Center
            noDataLabel.font = UIFont.systemFontOfSize(20)
            noDataLabel.textColor = UIColor.grayColor()
            tableView.backgroundView = noDataLabel
            return 0;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let MainNC = self.parentViewController!.parentViewController?.parentViewController as! UINavigationController
        MainNC.navigationBarHidden = true
        let composeButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "insertNewTask:")
        let homeButton = UIBarButtonItem(image: UIImage(named:"reveal-icon"), style: UIBarButtonItemStyle.Plain, target: self, action: "showMenu:")
        self.navigationItem.rightBarButtonItem = composeButton
        self.navigationItem.leftBarButtonItem = homeButton
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:
            UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
        
        Venmo.sharedInstance().defaultTransactionMethod = VENTransactionMethod.API

    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "taskDetail" || segue.identifier == "myTaskDetail" || segue.identifier == "requestedTaskDetail") {
            let svc = segue.destinationViewController as! ConfirmationViewController;
            let selectedIndex = self.tableView.indexPathForCell(sender as! PFTableViewCell)
            svc.selectedTask = self.objectAtIndexPath(selectedIndex)! as PFObject
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadObjects()
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }

    
    func insertNewTask(sender: AnyObject) {
        let vc : AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("RequestForm")
        self.showViewController(vc as! UIViewController, sender: vc)
        
        /*tasks.insert(Task(description: "new", price: 1, requestID: 0, expiration: 4), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)*/
    }
    
    func showMenu(sender: AnyObject){
        
        let CVC = self.navigationController?.parentViewController?.parentViewController?.parentViewController as! ContainerViewController
        CVC.showMenu()
        
    }
    
}
