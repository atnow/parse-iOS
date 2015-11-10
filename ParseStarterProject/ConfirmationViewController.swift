//
//  ConfirmationViewController.swift
//  atnow-iOS
//
//  Created by Benjamin Holland on 11/8/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class ConfirmationViewController: UIViewController {

    var selectedTask : PFObject?
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = selectedTask!["title"]! as? String

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptTask(sender: UIButton) {
        
        
        selectedTask!["accepter"] = PFUser.currentUser()
        selectedTask!.ACL?.setPublicWriteAccess(false)
        selectedTask?.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            if(!succeeded){
                let errorAlertController = UIAlertController(title: "Oops!", message: "Task already claimed", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                errorAlertController.addAction(OKAction)
                
                self.presentViewController(errorAlertController, animated: true) {}
                
            }
        })
        self.navigationController?.popViewControllerAnimated(true)
        
        
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
