//
//  PayViewController.swift
//  atnow-iOS
//
//  Created by Ben Ribovich on 1/12/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import Venmo_iOS_SDK

class PayViewController: UIViewController {
    
    var user : PFUser?
    var task : PFObject?
    var image : UIImage!
    
    var delegate : ConfirmationViewController?
    let designHelper = DesignHelper();
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    
    @IBOutlet weak var floatRatingView: FloatRatingView!
    
    @IBOutlet weak var costLabel: UILabel!

    @IBOutlet weak var extraTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*set up known info*/
        //picture
        profileImageView.layer.cornerRadius = 0.5 * self.profileImageView.frame.size.width
        profileImageView.clipsToBounds = true
        let imageFromParse = user!.objectForKey("profilePicture") as? PFFile
        if(imageFromParse != nil){
            imageFromParse!.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                let image: UIImage! = UIImage(data: imageData!)!
                self.profileImageView.image = image
                self.designHelper.formatPicture(self.profileImageView)
            })
        }
        designHelper.formatButton(submitButton)
        profileImageView.image = image
        
        //name
        nameLabel.text = user!["fullName"] as? String
        
        //task
        taskTitleLabel.text = "For task \"" + (task!["title"] as? String)! + "\""
        costLabel.text = "$" + "\(task!["price"] as!  NSNumber)"
        
        
    }
    
    @IBAction func submitPressed(sender: UIButton) {
        let rating = user!["rating"] as! PFObject
        
        rating.fetchInBackgroundWithBlock { (existingRating, error) -> Void in
            if(error==nil){
                let count = Float(existingRating!["ratingCount"] as! NSNumber)
                let newScore = (Float(existingRating!["rating"] as! NSNumber)*count + self.floatRatingView.rating)/(count+1) as NSNumber
                rating["rating"] = newScore
                rating["ratingCount"] = (count+1)
                rating.saveInBackgroundWithBlock { (success, error) -> Void in
                    
                }
            }
        }
        
        task!["confirmed"] = true
        task?.saveInBackgroundWithBlock({ (success, error) -> Void in
            if(error==nil){
                self.delegate?.setConfirmed()
                self.navigationController?.popViewControllerAnimated(true)
            }
        })
        
        let accepter = task!["accepter"] as! PFUser
        accepter.fetchInBackgroundWithBlock { (currentAccepter, error) -> Void in
            if(error != nil){
                //handle error
            }
            else {
                let transactionMessage = (PFUser.currentUser()!["fullName"] as! String) + " has confirmed completion of " + (self.task!["title"] as! String)
                
                let recipientHandle = currentAccepter!["venmoPhoneNumber"] as! String
                let transactionAudience = VENTransactionAudience.Private
                
                let total = (self.task!["price"] as! UInt) + UInt(self.extraTextField.text!)!
                
                Venmo.sharedInstance().sendPaymentTo(recipientHandle, amount: total , note: transactionMessage, audience: transactionAudience)
                    { (transaction, success, error) -> Void in
                    if(success){
                        print("success")
                    }
                    if ((error) != nil){
                        print(error)
                    }
                }
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

