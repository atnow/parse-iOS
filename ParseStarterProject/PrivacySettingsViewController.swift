//
//  PrivacySettingsViewController.swift
//  atnow-iOS
//
//  Created by Ben Ribovich on 2/29/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI
class PrivacySettingsViewController : UITableViewController{
    
    let designHelper = DesignHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let v = view as! UITableViewHeaderFooterView
        v.backgroundView!.backgroundColor = designHelper.menuBackgroundColor
        v.textLabel?.font = UIFont.systemFontOfSize(15, weight: UIFontWeightThin)
    }
}