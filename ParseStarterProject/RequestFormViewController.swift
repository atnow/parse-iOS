//
//  RequestFormViewController.swift
//  now
//
//  Created by Ben Ribovich on 10/29/15.
//  Copyright © 2015 Ben Ribovich. All rights reserved.
//

import UIKit
import Parse


class RequestFormViewController: UIViewController, UITextViewDelegate {
    
    let PLACEHOLDER_TEXT = "Further Instructions"
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var carIcon: UIImageView!
    @IBOutlet weak var liftingIcon: UIImageView!
    @IBOutlet weak var purchaseIcon: UIImageView!
    let designHelper = DesignHelper()
    var carSelected = false
    var purchaseSelected = false
    var liftingSelected = false

    
    @IBAction func submitPressed(sender: AnyObject) {
        
        let newTask = PFObject(className: "Task")
        newTask["title"] = self.titleTextField.text
        newTask["description"] = self.instructionsTextView.text
        newTask["taskLocation"] = self.locationTextField.text
        if(priceTextField.text == ""){
            newTask["price"] = 0
        } else {
            newTask["price"] = NSNumber(integer: Int(priceTextField.text!)!)
        }
        newTask["expiration"] = datePicker.date
        newTask["requester"] = PFUser.currentUser()
        newTask["accepted"] = false
        newTask["completed"] = false
        newTask["confirmed"] = false
        newTask["requiresCar"] = carSelected
        newTask["requiresPurchase"] = purchaseSelected
        newTask["requiresLifting"] = liftingSelected
        
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
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designHelper.formatButton(submitButton)
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        instructionsTextView.layer.borderWidth = 0.5
        instructionsTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        datePicker.layer.cornerRadius = 8
        datePicker.minimumDate = NSDate()
        instructionsTextView.layer.cornerRadius = 8
        
        instructionsTextView.delegate = self
        
        let carImage = UIImage(named: "car")
        let creditImage = UIImage(named: "credit-card")
        let liftingImage = UIImage(named: "heavy-lifting")
        
        carIcon.image = carImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        purchaseIcon.image = creditImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        liftingIcon.image = liftingImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        carIcon.tintColor = UIColor.lightGrayColor()
        purchaseIcon.tintColor = UIColor.lightGrayColor()
        liftingIcon.tintColor = UIColor.lightGrayColor()
        
        carIcon.backgroundColor = UIColor.whiteColor()
        purchaseIcon.backgroundColor = UIColor.whiteColor()
        liftingIcon.backgroundColor = UIColor.whiteColor()
        
        let carTapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("carImageTapped:"))
        let creditTapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("creditImageTapped:"))
        let liftingTapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("liftingImageTapped:"))
        carIcon.userInteractionEnabled = true
        purchaseIcon.userInteractionEnabled = true
        liftingIcon.userInteractionEnabled = true
        carIcon.addGestureRecognizer(carTapGestureRecognizer)
        purchaseIcon.addGestureRecognizer(creditTapGestureRecognizer)
        liftingIcon.addGestureRecognizer(liftingTapGestureRecognizer)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func carImageTapped(img: AnyObject)
    {
        // Your action
        if(carSelected){
             carIcon.tintColor = UIColor.lightGrayColor()
             carSelected = false
        } else{
            carIcon.tintColor = UIColor.blackColor()
            carSelected = true
        }
        
    }
    
    func creditImageTapped(img: AnyObject)
    {
        // Your action
        if(purchaseSelected){
            purchaseIcon.tintColor = UIColor.lightGrayColor()
            purchaseSelected = false
        } else{
            purchaseIcon.tintColor = UIColor.blackColor()
            purchaseSelected = true
        }
    }
    
    func liftingImageTapped(img: AnyObject)
    {
        // Your action
        if(liftingSelected){
            liftingIcon.tintColor = UIColor.lightGrayColor()
            liftingSelected = false
        } else{
            liftingIcon.tintColor = UIColor.blackColor()
            liftingSelected = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        // remove the placeholder text when they start typing
        // first, see if the field is empty
        // if it's not empty, then the text should be black and not italic
        // BUT, we also need to remove the placeholder text if that's the only text
        // if it is empty, then the text should be the placeholder
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0 // have text, so don't show the placeholder
        {
            // check if the only text is the placeholder and remove it if needed
            // unless they've hit the delete button with the placeholder displayed
            if textView == instructionsTextView && textView.text == PLACEHOLDER_TEXT
            {
                if text.utf16.count == 0 // they hit the back button
                {
                    return false // ignore it
                }
                applyNonPlaceholderStyle(textView)
                textView.text = ""
            }
            return true
        }
        else  // no text, so show the placeholder
        {
            applyPlaceholderStyle(textView, placeholderText: PLACEHOLDER_TEXT)
            moveCursorToStart(textView)
            return false
        }
    }
    
    func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String)
    {
        // make it look (initially) like a placeholder
        aTextview.textColor = UIColor.lightGrayColor()
        aTextview.text = placeholderText
    }
    
    func applyNonPlaceholderStyle(aTextview: UITextView)
    {
        // make it look like normal text instead of a placeholder
        aTextview.textColor = UIColor.darkTextColor()
        aTextview.alpha = 1.0
    }
    
    func textViewShouldBeginEditing(aTextView: UITextView) -> Bool
    {
        if aTextView == instructionsTextView && aTextView.text == PLACEHOLDER_TEXT
        {
            // move cursor to start
            moveCursorToStart(aTextView)
        }
        return true
    }
    
    func moveCursorToStart(aTextView: UITextView)
    {
        dispatch_async(dispatch_get_main_queue(), {
            aTextView.selectedRange = NSMakeRange(0, 0);
        })
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
