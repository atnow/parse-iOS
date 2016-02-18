
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
    
    var pictureChanged: Bool = false

    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var homeLabel: UILabel!
    
    @IBOutlet weak var starLabel: FloatRatingView!
    @IBOutlet weak var notificationsLabel: UILabel!
    
    @IBOutlet weak var settingsLabel: UILabel!
    
    @IBOutlet weak var helpCenterLabel: UILabel!
    
    @IBOutlet weak var homeIcon: UIImageView!
    
    @IBOutlet weak var bellIcon: UIImageView!
    
    @IBOutlet weak var settingsIcon: UIImageView!
    
    @IBOutlet weak var lifebuoyIcon: UIImageView!
    
    let designHelper = DesignHelper()
    
    @IBOutlet var menuTableView: UITableView! {
        didSet{
            menuTableView.delegate = self
            menuTableView.bounces = false
        }
    }
    @IBOutlet var profileImageView: UIImageView!
    
    var user: PFUser? =  PFUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeIcon.image = homeIcon.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        bellIcon.image = bellIcon.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        settingsIcon.image = settingsIcon.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        lifebuoyIcon.image = lifebuoyIcon.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        homeIcon.tintColor = designHelper.baseColor
        bellIcon.tintColor = designHelper.baseColor
        settingsIcon.tintColor = designHelper.baseColor
        lifebuoyIcon.tintColor = designHelper.baseColor
        
        fullNameLabel.textColor = designHelper.baseColor
        
        let mercuryColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        self.tableView.backgroundColor = mercuryColor
        PFUser.currentUser()?.fetchInBackgroundWithBlock({ (user, error) -> Void in
            if((error) != nil){
                print(error)
            }
            else{
                self.user = PFUser.currentUser()
                if (self.user?.username != nil){
                    self.loadPicture()
                    print(self.user!["fullName"])
                    self.fullNameLabel.text = self.user!["fullName"] as? String
                    //self.emailAddress.text = self.user!.email as String!
                    //self.emailAddress.textColor = self.designHelper.baseColor
                    
                    let query = PFQuery(className: "_User")
                    query.includeKey("rating")
                    query.getObjectInBackgroundWithId((user?.objectId)!) { (result, error) -> Void in
                        if error==nil{
                            self.user = result as? PFUser
                            if user?["rating"] != nil {
                                self.starLabel.rating = self.user!["rating"]["rating"] as! Float!
                            }
                            
                        } else{
                            print(error)
                        }
                    }
                }
                else{
                    print("nil username")
                }
            }
        })


        designHelper.formatPicture(profileImageView)
        homeLabel.textColor = designHelper.baseColor
        notificationsLabel.textColor = designHelper.baseColor
        settingsLabel.textColor = designHelper.baseColor
        helpCenterLabel.textColor = designHelper.baseColor
        
        let recognizer = UITapGestureRecognizer(target: self, action: "profileShow:")
        self.profileImageView.addGestureRecognizer(recognizer)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pictureChanged:", name: "pictureChanged", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear called")
        super.viewWillAppear(animated)
        if(pictureChanged){
            print("picture has changed")
            loadPicture()
        }
    }
    
    
    func profileShow(sender: UITapGestureRecognizer) {
        let center = NSNotificationCenter.defaultCenter()
        center.postNotification(NSNotification(name: Notifications.PictureSelected, object: self))
        let cvc = self.parentViewController as! ContainerViewController
        cvc.hideMenu()
        
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
        static let PictureSelected = "PictureSelected"
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
    
    func loadPicture(){
        user = PFUser.currentUser()
        let imageFromParse = user!.objectForKey("profilePicture") as? PFFile
        if(imageFromParse != nil){
            imageFromParse!.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                let image: UIImage! = UIImage(data: imageData!)!
                self.profileImageView.image = image
            })
        }
    }
    
    
    func pictureChanged(notification: NSNotification){
        print("pictureChanged was called")
        pictureChanged=true;
    }

}