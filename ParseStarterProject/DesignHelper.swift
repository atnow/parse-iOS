//
//  DesignHelper.swift
//  atnow-iOS
//
//  Created by Benjamin Holland on 11/14/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

public class DesignHelper {
    
    let baseColor = UIColor(red: 81/255, green: 190/255, blue: 248/255, alpha: 1.0)
    let fadeColor = UIColor(red: 81/255, green: 190/255, blue: 248/255, alpha: 0.2)
    
    let todoColor = UIColor.orangeColor()
    let awaitingConfirmationColor = UIColor.blueColor()
    let completeColor = UIColor(red: 17/255, green: 210/255, blue: 3/255, alpha: 1.0)
    let unclaimedColor = UIColor.grayColor()
    let inProgressColor = UIColor(red: 81/255, green: 190/255, blue: 248/255, alpha: 1.0)

    
    
    func formatButton (button: UIButton){
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = baseColor.CGColor
        button.setTitleColor(baseColor, forState: .Normal)
        button.layer.backgroundColor = UIColor.whiteColor().CGColor
        
    }
    
    func formatPicture (picture: UIImageView) {
        picture.layer.cornerRadius = picture.frame.size.width / 2
        picture.clipsToBounds = true
        picture.layer.borderWidth = 2
        picture.layer.borderColor = baseColor.CGColor        
    }
    
}