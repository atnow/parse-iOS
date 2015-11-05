//
//  Item.swift
//  now
//
//  Created by Ben Ribovich on 10/15/15.
//  Copyright © 2015 Ben Ribovich. All rights reserved.
//

import Foundation


class Task{
    
    var description: String?
    var price: Float?
    var location: String?
    var expiration: NSDate?
    var instructions: String?
    var requestID: Int?
    
    init(description: String?, price: Float?, location: String?, expiration: NSDate?, instructions:String?, requestID: Int?){
        
        self.description = description
        self.price = price
        self.location = location
        self.expiration = expiration
        self.instructions = instructions
        self.requestID = requestID
        
    }
    
    
}
