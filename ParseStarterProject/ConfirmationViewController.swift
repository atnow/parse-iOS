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
    var currentState = stateType.available
    enum stateType{
        case myTask
        case accepted
        case available
    }
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userRating: UILabel!
    
    @IBOutlet weak var instructionsView: UITextView!
    @IBOutlet weak var taskLocationLabel: UILabel!
    
    
    @IBOutlet weak var acceptButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        acceptButton.layer.cornerRadius = 0.5 * acceptButton.bounds.size.width
        acceptButton.layer.borderWidth = 2
        acceptButton.layer.borderColor = UIColor.cyanColor().CGColor
        if((selectedTask!["requester"] as! PFUser).objectId == PFUser.currentUser()?.objectId){
            acceptButton.setTitle("Cancel", forState: UIControlState.Normal)
            acceptButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            acceptButton.layer.borderColor = UIColor.redColor().CGColor
            currentState = .myTask
        }
            
        else if((selectedTask!["accepted"] as! Bool) == true){
            if ((selectedTask!["accepter"] as! PFUser).objectId == PFUser.currentUser()?.objectId){
                acceptButton.titleLabel?.numberOfLines = 2
                acceptButton.titleLabel?.textAlignment = NSTextAlignment.Center
                acceptButton.setTitle("Accepted \r\n" + "Click to relinquish task", forState: UIControlState.Normal)
                acceptButton.titleLabel?.adjustsFontSizeToFitWidth = true
                acceptButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
                acceptButton.layer.borderColor = UIColor.greenColor().CGColor
                currentState = .accepted
            }
        }
        
        
        let priceNum = selectedTask!["price"] as! NSNumber
        titleLabel.text = (selectedTask!["title"]! as? String)! + "($\(priceNum))"
        if (selectedTask!["taskLocation"] != nil){
            taskLocationLabel.text = selectedTask!["taskLocation"]! as? String
        } else {
            taskLocationLabel.hidden = true
        }
        
        userFullName.text = PFUser.currentUser()!["fullName"] as? String
        
        
        //let date = NSDate()
       // let expDate = selectedTask!["expiration"] as! NSDate
       // let timeToExpire = Int(expDate.timeIntervalSinceDate(date)/60)
       // expirationLabel.text = "Expires: \(Int(timeToExpire/60))" + ":" + "\(timeToExpire%60)"
       // instructionsView.text = selectedTask!["description"]! as? String
    
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClick(sender: UIButton) {
        
        switch currentState{
        case .available:
            acceptTask()
        case .accepted:
            unacceptTask()
        case .myTask:
            cancelTask()
        default:
            print("Invalid State")
        }
        
    }
 
    func acceptTask() {
        selectedTask!["accepter"] = PFUser.currentUser()
        selectedTask!["accepted"] = true
        selectedTask!.ACL?.setPublicWriteAccess(false)
        selectedTask?.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            if(!succeeded){
                let errorAlertController = UIAlertController(title: "Oops!", message: "Task already claimed", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                }

                errorAlertController.addAction(OKAction)
                
                self.presentViewController(errorAlertController, animated: true) {}
            }
            else{
                self.navigationController?.popViewControllerAnimated(true)
            }
        })
        
    }
    
    func unacceptTask(){
        let errorAlertController = UIAlertController(title: "Are you sure?", message: "Others will be able to claim this task", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in }
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.selectedTask!["accepted"] = false
                self.selectedTask!["accepter"] = nil
                self.selectedTask?.saveInBackground()
                self.navigationController?.popViewControllerAnimated(true)
            })
        }
        
        errorAlertController.addAction(cancelAction)
        errorAlertController.addAction(OKAction)
        self.presentViewController(errorAlertController, animated: true) {}
        
        
    }
    
    func cancelTask(){
        let errorAlertController = UIAlertController(title: "Are you sure?", message: "This will permanently delete your task", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in }
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.selectedTask?.deleteInBackground()
                self.navigationController?.popViewControllerAnimated(true)
            })
        }
        
        errorAlertController.addAction(cancelAction)
        errorAlertController.addAction(OKAction)
        self.presentViewController(errorAlertController, animated: true) {}
        
        
        
        
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
