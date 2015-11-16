//
//  MainNavigationController.swift
//  now
//
//  Created by Ben Ribovich on 10/20/15.
//  Copyright © 2015 Ben Ribovich. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController, UINavigationControllerDelegate{

    private var homeSelectedObserver: NSObjectProtocol?
    private var notificationsSelectedObserver: NSObjectProtocol?
    private var settingsSelectedObserver: NSObjectProtocol?
    private var helpCenterSelectedObserver: NSObjectProtocol?
    private var pictureSelectedObserver: NSObjectProtocol?
    
    let designHelper = DesignHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.navigationBar.backgroundColor = designHelper.baseColor
        let barColor = designHelper.baseColor.colorWithAlphaComponent(0.1)
        self.navigationBar.barTintColor = barColor
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    private func addObservers() {
        let center = NSNotificationCenter.defaultCenter()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        pictureSelectedObserver = center.addObserverForName(MenuViewController.Notifications.PictureSelected, object: nil, queue: nil) { (notification: NSNotification!) in
            let hvc = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController")
            self.setViewControllers([hvc], animated: false)
            
        }
        
        homeSelectedObserver = center.addObserverForName(MenuViewController.Notifications.HomeSelected, object: nil, queue: nil) { (notification: NSNotification!) in
            let hvc = storyboard.instantiateViewControllerWithIdentifier("TabBarController")
            self.setViewControllers([hvc], animated: false)
            
        }
        
        
        notificationsSelectedObserver = center.addObserverForName(MenuViewController.Notifications.NotificationsSelected, object: nil, queue: nil) { (notification: NSNotification!) in
            let hvc = storyboard.instantiateViewControllerWithIdentifier("NotificationsViewController")
            self.setViewControllers([hvc], animated: false)
            
        }
        
        settingsSelectedObserver = center.addObserverForName(MenuViewController.Notifications.SettingsSelected, object: nil, queue: nil) { (notification: NSNotification!) in
            let hvc = storyboard.instantiateViewControllerWithIdentifier("SettingsViewController")
            self.setViewControllers([hvc], animated: false)
            
        }

        helpCenterSelectedObserver = center.addObserverForName(MenuViewController.Notifications.HelpCenterSelected, object: nil, queue: nil) { (notification: NSNotification!) in
            let hvc = storyboard.instantiateViewControllerWithIdentifier("HelpCenterViewController")
            self.setViewControllers([hvc], animated: false)
            
        }
        

    }
    
    func showMenu(sender: AnyObject){
        
        let CVC = self.parentViewController as! ContainerViewController
        CVC.showMenu()
        
    }
    
    private func removeObservers(){
        let center = NSNotificationCenter.defaultCenter()
        
        if homeSelectedObserver !=  nil {
            center.removeObserver(homeSelectedObserver!)
        }

//        if greenSelectedObserver != nil {
//            center.removeObserver(greenSelectedObserver!)
//        }
    }
    
}
