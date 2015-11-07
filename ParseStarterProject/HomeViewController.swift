//
//  HomeViewController.swift
//  now
//
//  Created by Ben Ribovich on 10/15/15.
//  Copyright © 2015 Ben Ribovich. All rights reserved.
//

import UIKit

let isLocalHostTesting = false
let localHostRpcUrl = "https://localhost:8080/_ah/api/rpc?prettyPrint=false"
let noTasksCellIdentifier = "NoTasksCell"
var initialQueryComplete = false

class HomeViewController : UITableViewController {
    
    var tasks: [Task] = taskData
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let MainNC = self.parentViewController?.parentViewController?.parentViewController as! UINavigationController
        MainNC.navigationBarHidden = true
        let composeButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "insertNewTask:")
        let homeButton = UIBarButtonItem(image: UIImage(named:"reveal-icon"), style: UIBarButtonItemStyle.Plain, target: self, action: "showMenu:")
        self.navigationItem.rightBarButtonItem = composeButton
        self.navigationItem.leftBarButtonItem = homeButton
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)


    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            var cell: UITableViewCell
            
            if tasks.count==0 {
                cell = tableView.dequeueReusableCellWithIdentifier(noTasksCellIdentifier, forIndexPath: indexPath)
                
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier("TaskCell", forIndexPath: indexPath)

//                print(indexPath.row)
//                let task = tasks[indexPath.row] as Task
//                print(task.JSONValueForKey("description"))
//                print(task.description)
//                if let descriptionLabel = cell.viewWithTag(100) as? UILabel {
//                let description = task.JSONValueForKey("description")
//                descriptionLabel.text = "\(description)"
//                }
//
//                if let priceLabel = cell.viewWithTag(101) as? UILabel {
//                    let price = task.JSONValueForKey("price")
//                    print(price)
//                    priceLabel.text = "$" + String(price)
//                    
//                }
//                if let expirationLabel = cell.viewWithTag(102) as? UILabel {
//                    //let exp = task.JSONValueForKey("timeRequested")
//                  //  let expDate = NSDate(exp)
//                   // expirationLabel.text =  + "h"
//                }
            }
            
          return cell
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
    
    //MARK: - Private helper methods
//    
//    func _showErrorDialog(error: NSError){
//        let alertController = UIAlertController(title: "Endpoints Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
//        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
//        alertController.addAction(defaultAction)
//        presentViewController(alertController, animated: true, completion: nil)
//    }
//    
//    func _queryForQuotes() {
//        let query = GTLQueryAtnow.queryForTasksList() as GTLQueryAtnow
//        
//        service.executeQuery(query) { (ticket, response, error) -> Void in
//            if error != nil {
//                self._showErrorDialog(error!)
//            } else {
//                let taskCollection = response as! GTLAtnowTaskCollection
//                self.gtlTasks = taskCollection.items() as! [GTLAtnowTask]
//            }
//            self.tableView.reloadData()
//        }
//    }
    
}
