//
//  RequestFormViewController.swift
//  now
//
//  Created by Ben Ribovich on 10/29/15.
//  Copyright © 2015 Ben Ribovich. All rights reserved.
//

import UIKit
import Parse


class RequestFormViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBAction func submitPressed(sender: AnyObject) {
        
        let newTask = PFObject(className: "Task")
        newTask["title"] = self.titleTextField.text
        newTask["description"] = self.instructionsTextView.text
        newTask["price"] = NSNumber(integer: Int(priceTextField.text!)!)
        newTask["expiration"] = datePicker.date
        newTask["requester"] = PFUser.currentUser()
        newTask.ACL?.setPublicWriteAccess(true)
        newTask.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                
                // Task has been saved.
                let successAlertController = UIAlertController(title: "Success!", message: "This task has been created", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                }

                successAlertController.addAction(OKAction)
                self.presentViewController(successAlertController, animated: true) {}
                
            } else {
                
                //Issue saving task
                let errorAlertController = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                }

                errorAlertController.addAction(OKAction)
                self.presentViewController(errorAlertController, animated: true) {}
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionsTextView.layer.borderWidth = 1
        instructionsTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        // Do any additional setup after loading the view.
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
