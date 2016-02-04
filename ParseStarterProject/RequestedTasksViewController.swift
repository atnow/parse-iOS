//
//  RequestedTasksViewController.swift
//  atnow-iOS
//
//  Created by Benjamin Holland on 2/2/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class RequestedTasksViewController: UIViewController {

    @IBOutlet weak var stages: UISegmentedControl!
    
    let designHelper = DesignHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let MainNC = self.parentViewController?.parentViewController?.parentViewController as! UINavigationController
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
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func stageChanged(sender: UISegmentedControl) {
        
        let currStage = stages.selectedSegmentIndex
        
        switch currStage {
        case 0:
            stages.tintColor = designHelper.todoColor
        case 1:
            stages.tintColor = designHelper.todoColor
        case 2:
            stages.tintColor = designHelper.awaitingConfirmationColor
        case 3:
            stages.tintColor = designHelper.completeColor
        default:
            stages.tintColor = UIColor.blueColor()
        }
        NSNotificationCenter.defaultCenter().postNotificationName("tabSelected", object: nil, userInfo: ["number": currStage])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


