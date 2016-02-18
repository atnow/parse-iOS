//
//  ProfileFeedViewController.swift
//  atnow-iOS
//
//  Created by Benjamin Holland on 1/28/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileFeedViewController: HomeViewController {
    
    var user : PFUser?

    override func viewDidLoad() {
//        let parentVC = self.parentViewController as! ProfileViewController
//        self.user = parentVC.user
        // Do any additional setup after loading the view.
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
        
        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        if self.objects!.count == 0 {
            query.cachePolicy = .CacheThenNetwork
        }
        
        query.whereKey("accepter", equalTo: self.user! )
        query.whereKey("confirmed", equalTo: true)
        query.orderByAscending("expiration")
        
        return query
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if(self.objects?.count != 0){
            tableView.backgroundView = nil
            return 1;
            
        }
        else{
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
            noDataLabel.text = "You haven't completed any taks yet"
            noDataLabel.textAlignment = NSTextAlignment.Center
            noDataLabel.font = UIFont.systemFontOfSize(20)
            noDataLabel.textColor = UIColor.grayColor()
            tableView.backgroundView = noDataLabel
            return 0;
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "profileFeedTaskDetail") {
            let svc = segue.destinationViewController as! ConfirmationViewController;
            let selectedIndex = self.tableView.indexPathForCell(sender as! PFTableViewCell)
            svc.selectedTask = self.objectAtIndexPath(selectedIndex)! as PFObject
            
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
