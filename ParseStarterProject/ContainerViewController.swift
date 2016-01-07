//
//  ContainerViewController.swift
//  now
//
//  Created by Benjamin Holland on 10/19/15.
//  Copyright © 2015 Ben Ribovich. All rights reserved.
//

import UIKit
import Parse

class ContainerViewController: UIViewController {
    var leftViewController: UIViewController? {
        willSet{
            if self.leftViewController != nil {
                if self.leftViewController!.view != nil {
                    self.leftViewController!.view!.removeFromSuperview()
                }
                self.leftViewController!.removeFromParentViewController()
            }
        }
        
        didSet{
            self.view!.addSubview(self.leftViewController!.view)
            self.addChildViewController(self.leftViewController!)
        }
    }
    
    var rightViewController: UIViewController? {
        willSet {
            if self.rightViewController != nil {
                if self.rightViewController!.view != nil {
                    self.rightViewController!.view!.removeFromSuperview()
                }
                self.rightViewController!.removeFromParentViewController()
            }
        }
        
        didSet{
            
            self.view!.addSubview(self.rightViewController!.view)
            self.addChildViewController(self.rightViewController!)
        }
    }
    
    var menuShown: Bool = false
    
//    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
//        showMenu()
//        
//    }
//    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
//        hideMenu()
//    }
    
    
    func showMenu() {
        UIView.animateWithDuration(0.3, animations: {
            self.rightViewController!.view.frame = CGRect(x: self.view.frame.origin.x + 235, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
            }, completion: { (Bool) -> Void in
                self.menuShown = true
        })
        let tap = UITapGestureRecognizer(target: self, action: Selector("hideMenu"))
        self.rightViewController!.view.addGestureRecognizer(tap)
        self.rightViewController!.navigationController?.navigationBar.addGestureRecognizer(tap)
    }
    
    func hideMenu() {
        UIView.animateWithDuration(0.3, animations: {
            self.rightViewController!.view.frame = CGRect(x: 0, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
            }, completion: { (Bool) -> Void in
                self.menuShown = false
        })
        self.rightViewController?.navigationController?.navigationBar.gestureRecognizers?.removeAll()
        self.rightViewController!.view.gestureRecognizers?.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (PFUser.currentUser()?.username == nil) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: { () -> Void in
                    self.instanstiateContainer()

                })
            })
        }
        else{
            instanstiateContainer()
        }

    }
    
    func instanstiateContainer(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainNavigationController: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController
        let menuViewController: MenuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController")as! MenuViewController
        menuViewController.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.leftViewController = menuViewController
        self.rightViewController = mainNavigationController
    }

}
