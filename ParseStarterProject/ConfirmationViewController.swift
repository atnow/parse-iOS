//
//  ConfirmationViewController.swift
//  atnow-iOS
//
//  Created by Benjamin Holland on 11/8/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class ConfirmationViewController: UIViewController, UIPopoverPresentationControllerDelegate,PayViewControllerDelegate {

    var selectedTask : PFObject?
    var currentState = stateType.available
    var myTask = false
    var requester : PFUser?
    var accepter: PFUser?
    let designHelper = DesignHelper()
    
    enum stateType{
        case available
        case accepted
        case completed
        case confirmed
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var ratingStarView: FloatRatingView!
    @IBOutlet weak var instructionsView: UITextView!
    @IBOutlet weak var taskLocationLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var grayBar: UIView!
//    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var ARPicture: UIImageView!
    @IBOutlet weak var ARLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designHelper.formatButtonAction(acceptButton)
        acceptButton.titleLabel?.textAlignment = NSTextAlignment.Center
        acceptButton.titleLabel?.numberOfLines = 2
        acceptButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        designHelper.formatButton(reportButton)
        reportButton.layer.borderColor = UIColor.redColor().CGColor
        reportButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        reportButton.hidden = true
        
//        buttonImage.hidden = true
//        buttonImage.layer.cornerRadius = 0.5*buttonImage.frame.size.width
//        buttonImage.clipsToBounds = true
//
        
        ARPicture.layer.cornerRadius = 0.5 * self.ARPicture.frame.size.width
        ARPicture.clipsToBounds = true
        
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.sizeToFit()
        let priceNum = selectedTask!["price"] as! NSNumber
        titleLabel.text = (selectedTask!["title"]! as? String)!
        priceLabel.text = "$\(priceNum)"
        
        
        let date = NSDate()
        let expDate = selectedTask!["expiration"] as! NSDate
        let timeToExpire = Int(expDate.timeIntervalSinceDate(date)/60)
        let days = "\(Int(timeToExpire/1440))" + "d "
        var expiration : String
        if timeToExpire <= 0 {
            expiration = "Expired"
        } else if (Int(timeToExpire/1440) == 0) {
            expiration =  "\(Int(timeToExpire%1440)/60)" + "h " + "\(timeToExpire%60)" + "m"
        }
        else{
            expiration =  days + "\(Int(timeToExpire%1440)/60)" + "h " + "\(timeToExpire%60)" + "m"
        }
        if ((selectedTask!["taskLocation"] as! String != "") && (timeToExpire > 0)){
            taskLocationLabel.text = (selectedTask!["taskLocation"]! as? String)!
        } else {
            taskLocationLabel.text = "N/A"
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .MediumStyle
        
        expirationLabel.text = "Complete by " + dateFormatter.stringFromDate(expDate)
        
        durationLabel.text = expiration
        taskLocationLabel.adjustsFontSizeToFitWidth=true
        
        instructionsView.text = (selectedTask!["description"]! as? String)!
        
        let query = PFQuery(className:"_User")
        query.includeKey("rating")
        
        if((selectedTask!["requester"] as! PFUser).objectId == PFUser.currentUser()?.objectId){
            myTask = true
            if((selectedTask!["accepted"] as! Bool) == true){
                query.getObjectInBackgroundWithId(selectedTask!["accepter"].objectId!!) {
                    (user: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        self.ARLabel.text="Accepter"
                        self.accepter = user as? PFUser
                        self.userFullName.text = user!["fullName"] as? String
                        let imageFromParse = user!.objectForKey("profilePicture") as? PFFile
                        if(imageFromParse != nil){
                            imageFromParse!.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                                let image: UIImage! = UIImage(data: imageData!)!
                                self.ARPicture.image = image
                                self.designHelper.formatPicture(self.ARPicture)
                            })
                        }
                        
                        self.ratingStarView.rating = user!["rating"]["rating"] as! Float
                        
                        let recognizer = UITapGestureRecognizer(target: self, action: "picturePressed:")
                        self.grayBar.tag = 1
                        self.grayBar.addGestureRecognizer(recognizer)
                        
                        
                    } else {
                        print(error)
                    }
                }
            }
            else{
                grayBar.hidden = true
            }
        }
        else{ //we are the accepter
            myTask = false
            query.getObjectInBackgroundWithId(selectedTask!["requester"].objectId!!) {
                (user: PFObject?, error: NSError?) -> Void in
                if error == nil {
                    self.requester = user as? PFUser
                    self.userFullName.text = user!["fullName"] as? String
                    let imageFromParse = user!.objectForKey("profilePicture") as? PFFile
                    if(imageFromParse != nil){
                        imageFromParse!.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                            let image: UIImage! = UIImage(data: imageData!)!
                            self.ARPicture.image = image
                            self.designHelper.formatPicture(self.ARPicture)
                        })
                    }
                    
                    self.ratingStarView.rating = user!["rating"]["rating"] as! Float
                    
                    let recognizer = UITapGestureRecognizer(target: self, action: "picturePressed:")
                    self.grayBar.tag = 1
                    self.grayBar.addGestureRecognizer(recognizer)
                    
                    
                } else {
                    print(error)
                }
            }
            
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        if(myTask){
            myTask = true
            //currentState = .myTask
            
            if((selectedTask!["completed"] as! Bool) == true){
                
                if((selectedTask!["confirmed"] as! Bool) == true){
                    currentState = .confirmed
                    designHelper.formatButtonNoAction(acceptButton)
                    acceptButton.enabled = false
                    acceptButton.setTitle("Complete", forState: UIControlState.Normal)
                    
                }
                else{
                    currentState = .completed
                    designHelper.formatButtonAction(acceptButton)
                    acceptButton.setTitle("Completed \r\n" + "Press to Confirm", forState: UIControlState.Normal)
                    let reportButton = UIBarButtonItem(title: "Not complete?", style: .Plain, target: self, action: "report")
                    self.navigationItem.rightBarButtonItem = reportButton
                    /*reportButton.setTitle("Report", forState: UIControlState.Normal)
                    reportButton.hidden = false*/
                    /*let accepterQuery = PFQuery(className:"_User")
                    accepterQuery.getObjectInBackgroundWithId(selectedTask!["accepter"].objectId!!) {
                        (user: PFObject?, error: NSError?) -> Void in
                        if error == nil {
                            self.accepter = user as? PFUser
                            
                        } else {
                            print(error)
                        }
                    }*/
                }
                
            }
                
            else if((selectedTask!["accepted"] as! Bool) == true ){
                acceptButton.enabled = false
                //let color = UIColor(red: 255/255, green: 235/255, blue: 61/255, alpha: 1)
                //acceptButton.layer.borderColor = color.CGColor
                designHelper.formatButtonNoAction(acceptButton)
                acceptButton.setTitle("Task \r\n accepted", forState: UIControlState.Normal)
                //acceptButton.setTitleColor(color, forState: UIControlState.Normal)
                
 //               buttonImage.hidden=false
                /*let accepterQuery = PFQuery(className:"_User")
                accepterQuery.getObjectInBackgroundWithId(selectedTask!["accepter"].objectId!!) {
                    (user: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        self.accepter = user as? PFUser
                        let imageFromParse = user!.objectForKey("profilePicture") as? PFFile
                        if(imageFromParse != nil){
                            imageFromParse!.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
   //                             let image: UIImage! = UIImage(data: imageData!)!
   //                             self.buttonImage.image = image
                            })
                        }
                        
                    } else {
                        print(error)
                    }
                }*/
    //            let recognizer = UITapGestureRecognizer(target: self, action: "picturePressed:")
    //            buttonImage.tag = 2
    //            buttonImage.addGestureRecognizer(recognizer)
                
                
            }
                
            else{ //not accepted yet
                //cancelButton.hidden = false
                let deleteButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "cancelTask")
                self.navigationItem.rightBarButtonItem = deleteButton
                acceptButton.enabled = false
                currentState = .available
                designHelper.formatButtonNoAction(acceptButton)
                acceptButton.setTitle("Task \r\n" + "requested", forState: UIControlState.Normal)
            }
        }
            
        else if((selectedTask!["accepted"] as! Bool) == true){
            myTask = false
            reportButton.setTitle("Decline Task", forState: .Normal)
            if ((selectedTask!["accepter"] as! PFUser).objectId == PFUser.currentUser()?.objectId){
                
                if((selectedTask!["confirmed"] as! Bool) == true){
                    currentState = .confirmed
                    acceptButton.enabled = false
                    //acceptButton.layer.borderColor = UIColor.greenColor().CGColor
                    designHelper.formatButtonNoAction(acceptButton)
                    acceptButton.setTitle("Complete", forState: UIControlState.Normal)
                }
                    
                else if((selectedTask!["completed"] as! Bool) == true){
                    currentState = .completed
                    acceptButton.enabled = false
                    //let color = UIColor(red: 255/255, green: 235/255, blue: 61/255, alpha: 1)
                    //acceptButton.layer.borderColor = color.CGColor
                    designHelper.formatButtonNoAction(acceptButton)
                    acceptButton.setTitle("Waiting \r\n for confirmation", forState: UIControlState.Normal)
                    
                }
                else{
                    reportButton.hidden = false
                    let releaseButton = UIBarButtonItem(title: "Release", style: .Plain, target: self, action: "unacceptTask")
                    self.navigationItem.rightBarButtonItem = releaseButton
                    currentState = .accepted
                    designHelper.formatButtonAction(acceptButton)
                    acceptButton.setTitle("Press \r\n when complete", forState: UIControlState.Normal)
                    //acceptButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
                    //acceptButton.layer.borderColor = UIColor.greenColor().CGColor
                    currentState = .accepted
                }
            }
        }
        else{ //state is available
            myTask = false
            reportButton.hidden = true
        }
    }

    
    @IBAction func buttonClick(sender: UIButton) {
        if (myTask){
            switch currentState{
            case .completed:
                confirmTask()
            default:
                print("Invalid State")
            }
        }
        else{
            switch currentState{
            case .available:
                acceptTask()
            case .accepted:
                completeTask()
            default:
                print("Invalid State")
            }
        }
    }
    func acceptTask() {
        self.accepter = PFUser.currentUser()
        selectedTask!["accepter"] = self.accepter
        selectedTask!["accepted"] = true
        selectedTask!.ACL?.setPublicWriteAccess(false)
        selectedTask!.ACL?.setWriteAccess(true, forUser: PFUser.currentUser()!)
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
                self.designHelper.formatButtonNoAction(self.acceptButton)
                
                self.navigationController?.popViewControllerAnimated(true)
                
                let taskName = self.selectedTask!["title"] as! String
                //let acceptName = self.selectedTask!["accepter"]!["fullName"] as! String
                let acceptName = PFUser.currentUser()?.objectForKey("fullName") as! String
                let description = "Your task \"" + taskName + "\" was claimed by " + acceptName
                
                let notification = PFObject(className:"Notification")
                notification["owner"] = self.requester
                notification["type"] = "claimed"
                notification["isRead"] = false
                notification["task"] = self.selectedTask
                notification["message"] = description
                notification.saveInBackgroundWithBlock { (object, error) -> Void in
                    if (error != nil){
                        print(error)
                        
                    }
                }
            }
        })
                
    }
    
    func unacceptTask(){
        let errorAlertController = UIAlertController(title: "Are you sure?", message: "Others will be able to claim this task", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in }
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.selectedTask!["accepted"] = false
                self.selectedTask!["accepter"] = NSNull()
                self.selectedTask?.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                        self.designHelper.formatButtonAction(self.acceptButton)
                    } else {
                        print(error)
                    }
                }
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
                self.selectedTask?.delete(self)
                //self.selectedTask?.deleteInBackground()
                self.navigationController?.popViewControllerAnimated(true)
            })
        }
        
        errorAlertController.addAction(cancelAction)
        errorAlertController.addAction(OKAction)
        self.presentViewController(errorAlertController, animated: true) {}
   
    }
    
    func rate(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let payViewController: PayViewController = storyboard.instantiateViewControllerWithIdentifier("PayViewController") as! PayViewController
        payViewController.user = accepter
        payViewController.task = selectedTask
        self.navigationController?.pushViewController(payViewController, animated: false);

        
    }
    
    func report(){
        
        let reporter : PFUser?
        let offender : PFUser?
        if(myTask){
            reporter = PFUser.currentUser()
            offender = accepter
            
        }
        else{
            reporter = PFUser.currentUser()
            offender = requester
        }
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Report " + "\(offender!["fullName"])", message: "Enter your claim here", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            //textField.text = "Some default text."
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Report", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            //print("Text field: \(textField.text)")
            
            let newReport = PFObject(className: "Report")
            newReport["dealtWith"] = false
            newReport["detail"] = textField.text
            newReport["offender"] = offender
            newReport["reporter"] = reporter
            newReport["Task"] = self.selectedTask
            
            newReport.saveInBackgroundWithBlock({ (success, error) -> Void in
                if(success){
                    let submittedAlertController = UIAlertController(title: "Response Submitted", message: "Thank you for your report. We are looking into it and will get back to you shortly", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                        
                    }
                    submittedAlertController.addAction(OKAction)
                    self.presentViewController(submittedAlertController, animated: true){}
    
                }
                    
                else{
                    //Issue saving report
                    let errorAlertController = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    }
                    errorAlertController.addAction(OKAction)
                    self.presentViewController(errorAlertController, animated: true) {}
                }
            })
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
            
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func completeTask(){
        
        selectedTask!["completed"] = true
        selectedTask?.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            if(!succeeded){
                let errorAlertController = UIAlertController(title: "Oops!", message: "Something went wrong", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                }
                errorAlertController.addAction(OKAction)
                self.presentViewController(errorAlertController, animated: true) {}
            }
            else{
                let successController = UIAlertController(title: "Thank you!", message: "The requester will  be notified and you will recieve payment shortly", preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                }
                
                let taskName = self.selectedTask!["title"] as! String
                let acceptName = PFUser.currentUser()!["fullName"] as! String
                let description = "Your task \"" + taskName + "\" was completed by " + acceptName
                
                let notification = PFObject(className:"Notification")
                notification["owner"] = self.requester
                notification["type"] = "completed"
                notification["isRead"] = false
                notification["task"] = self.selectedTask
                notification["message"] = description
                notification.saveInBackgroundWithBlock { (object, error) -> Void in
                    if (error != nil){
                        print(error)
                        
                    }
                }                
                successController.addAction(OKAction)
                self.presentViewController(successController, animated: true){}
                
                
            }
        })
    }
    
    func confirmTask(){
        self.rate()

    }

//    @IBAction func infoAction(sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let instructionsVC = storyboard.instantiateViewControllerWithIdentifier("InstructionsViewController")
//        instructionsVC.modalPresentationStyle = .Popover
//        instructionsVC.preferredContentSize = CGSizeMake(400, 300)
//        let popoverVC = instructionsVC.popoverPresentationController
//        popoverVC?.permittedArrowDirections = .Down
//        popoverVC?.delegate = self
//        popoverVC?.sourceView = sender
//        popoverVC?.sourceRect = CGRect(
//            x: sender.frame.width/2,
//            y: sender.frame.height/2,
//            width: 1,
//            height: 1)
//        
//        if let descriptionLabel = instructionsVC.view.viewWithTag(300) as? UITextView {
//            let description = selectedTask!["description"]
//            descriptionLabel.text = "\(description)"
//        }
//        self.presentViewController(instructionsVC, animated: true, completion: nil)
//    }
    
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
            return .None
    }
    
    @IBAction func cancelButtonAction(sender: UIButton) {
        if(myTask){
            switch currentState{
            case stateType.completed:
                report()
            default:
                cancelTask()
            }
        }
        else{
            unacceptTask()
        }
    }
    
    
    func picturePressed(sender:UITapGestureRecognizer){
        if(myTask){
            performSegueWithIdentifier("showProfile", sender: self.accepter)
        }
        
        else{
            performSegueWithIdentifier("showProfile", sender: self.requester)
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier=="showProfile"){
            
            let user = sender as! PFUser
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.user = user
            
        }
    }
    
    func setConfirmed() {
        currentState = stateType.confirmed
        reportButton.hidden = true
        
        let taskName = self.selectedTask!["title"] as! String
       
        //let requestName = self.requester!["fullName"] as! String
        let requestName = PFUser.currentUser()?.objectForKey("fullName") as! String
        let description = requestName + " confirmed your completion of \"" + taskName + "\""
        
        let notification = PFObject(className:"Notification")
        notification["owner"] = self.accepter
        notification["type"] = "confirmed"
        notification["isRead"] = false
        notification["task"] = self.selectedTask
        notification["message"] = description
        notification.saveInBackgroundWithBlock { (object, error) -> Void in
            if (error != nil){
                print(error)
                
            }
        }
    
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


protocol PayViewControllerDelegate{
    func setConfirmed()
}