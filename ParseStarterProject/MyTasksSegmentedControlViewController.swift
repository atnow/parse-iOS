//
//  HomeTasksSegmentedControlViewController.swift
//  atnow-iOS
//
//  Created by Benjamin Holland on 2/2/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class MyTasksSegmentedControlViewController: UIViewController {
    
    let designHelper = DesignHelper()
    
    @IBOutlet weak var stages: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        let MainNC = self.parentViewController?.parentViewController?.parentViewController as! UINavigationController
        MainNC.navigationBarHidden = true
        let composeButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "insertNewTask:")
        let homeButton = UIBarButtonItem(image: UIImage(named:"reveal-icon"), style: UIBarButtonItemStyle.Plain, target: self, action: "showMenu:")
        self.navigationItem.rightBarButtonItem = composeButton
        self.navigationItem.leftBarButtonItem = homeButton
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:
            UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func changedStage(sender: AnyObject) {
        
        let currStage = stages.selectedSegmentIndex
        
        switch currStage {
        case 1:
            stages.tintColor = designHelper.todoColor
        case 2:
            stages.tintColor = designHelper.awaitingConfirmationColor
        case 3:
            stages.tintColor = designHelper.completeColor
        default:
            stages.tintColor = UIColor.blueColor()
        }
        
        
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
