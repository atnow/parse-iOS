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
    
    let baseColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
    
    func formatButton (button: UIButton){
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = baseColor.CGColor
        button.titleLabel?.textColor = baseColor
    }
    
    func formatPicture (picture: UIImageView) {
        
        
    }
    
}