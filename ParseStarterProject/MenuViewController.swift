
//
//  MenuViewController.swift
//  now
//
//  Created by Benjamin Holland on 10/20/15.
//  Copyright © 2015 Ben Ribovich. All rights reserved.
//

import UIKit
import Parse

class MenuViewController: UITableViewController{

    @IBOutlet weak var homeLabel: UILabel!
    
    @IBOutlet weak var notificationsLabel: UILabel!
    
    @IBOutlet weak var settingsLabel: UILabel!
    
    @IBOutlet weak var helpCenterLabel: UILabel!
    
    let designHelper = DesignHelper()
    
    @IBOutlet var menuTableView: UITableView! {
        didSet{
            menuTableView.delegate = self
            menuTableView.bounces = false
        }
    }
    @IBOutlet var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.3)
        let user = PFUser.currentUser()
        if (user != nil){
            let imageFromParse = user!.objectForKey("profilePicture") as? PFFile
            if(imageFromParse != nil){
                imageFromParse!.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                    let image: UIImage! = UIImage(data: imageData!)!
                    self.profileImageView.image = image
                })
            }
        }
        

        designHelper.formatPicture(profileImageView)
        homeLabel.textColor = designHelper.baseColor
        notificationsLabel.textColor = designHelper.baseColor
        settingsLabel.textColor = designHelper.baseColor
        helpCenterLabel.textColor = designHelper.baseColor
    }
    
    private func roundingUIView(let aView: UIView!, let cornerRadiusParam: CGFloat!) {
        aView.clipsToBounds = true
        aView.layer.cornerRadius = cornerRadiusParam
    }
    
    struct Notifications {
        static let HomeSelected = "HomeSelected"
        static let NotificationsSelected = "NotificationsSelected"
        static let SettingsSelected = "SettingsSelected"
        static let HelpCenterSelected = "HelpCenterSelected"
    }
    
//    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        cell?.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.3)
////        let backgroundView = UIView()
////        backgroundView.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.3)
////        cell?.backgroundView = backgroundView
//    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let item = indexPath.item
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        cell?.contentView.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.3)

        
        
//        let cell = tableView.cellForRowAtIndexPath(indexPath)
//        let backgroundView = UIView()
//        //backgroundView.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.3)
//        cell?.backgroundView = backgroundView
////        cell?.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.3)
//
        let center = NSNotificationCenter.defaultCenter()
        switch item {
        case 0:
            center.postNotification(NSNotification(name: Notifications.HomeSelected, object: self))
        case 1:
            center.postNotification(NSNotification(name: Notifications.NotificationsSelected, object: self))
        case 2:
            center.postNotification(NSNotification(name: Notifications.SettingsSelected, object: self))
        case 3:
            center.postNotification(NSNotification(name: Notifications.HelpCenterSelected, object: self))
        default:
            print("Unrecognized menu index")
            return
        }
        let cvc = self.parentViewController as! ContainerViewController
        cvc.hideMenu()
    }
}