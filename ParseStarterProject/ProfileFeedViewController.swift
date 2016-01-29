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

    override func viewDidLoad() {

        // Do any additional setup after loading the view.
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
        
        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        if self.objects!.count == 0 {
            query.cachePolicy = .CacheThenNetwork
        }
        
        query.whereKey("accepter", equalTo: PFUser.currentUser()! )
        query.orderByAscending("expiration")
        
        return query
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
