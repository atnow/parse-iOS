//
//  atnow_iOSTests.swift
//  atnow-iOSTests
//
//  Created by Benjamin Holland on 1/19/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import XCTest
import Parse
import ParseUI
@testable import atnow_iOS

class atnow_iOSTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let user = PFUser()
        user.email = "Test User"
        user.password = "password"
        
        PFUser.logInWithUsernameInBackground(user.email!, password: user.password!, block: { (user, error) -> Void in
            
        })
        
        
        let task = PFObject(className: "Task")
        task["title"] = "Test Task"
        task["description"] = "Test Description"
        task["expiration"] = NSDate(timeIntervalSinceNow: 1000)
        task["taskLocation"] = "Test Location"
        task["price"] = NSNumber(integer: 1)
        task["requester"] = PFUser.currentUser()
        task["accepted"] = false
        task["completed"] = false
        task["confirmed"] = false
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
