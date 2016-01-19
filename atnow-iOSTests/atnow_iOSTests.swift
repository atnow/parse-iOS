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
    var user : PFUser?
    var task: PFObject?
    var expiredTask : PFObject?
    

    override func setUp() {
        user = PFUser()
        task = PFObject(className: "Task")
        expiredTask = PFObject(className: "Task")
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        user!.email = "test@dartmouth.edu"
        user!.password = "password"
        
        PFUser.logInWithUsernameInBackground(user!.email!, password: user!
            
            .password!, block: { (user, error) -> Void in
            
                self.task!["title"] = "Test Task"
                self.task!["description"] = "Test Description"
                self.task!["expiration"] = NSDate(timeIntervalSinceNow: 1000)
                self.task!["taskLocation"] = "Test Location"
                self.task!["price"] = NSNumber(integer: 1)
                self.task!["requester"] = PFUser.currentUser()
                self.task!["accepted"] = false
                self.task!["completed"] = false
                self.task!["confirmed"] = false
                
                self.expiredTask!["title"] = "Test Task Expired"
                self.expiredTask!["description"] = "Test Description Expired"
                self.expiredTask!["expiration"] = NSDate(timeIntervalSinceNow: -1)
                self.expiredTask!["taskLocation"] = "Test Location Expired"
                self.expiredTask!["price"] = NSNumber(integer: 1)
                self.expiredTask!["requester"] = PFUser.currentUser()
                self.expiredTask!["accepted"] = false
                self.expiredTask!["completed"] = false
                self.expiredTask!["confirmed"] = false
        })
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        //task!.deleteInBackground()
        expiredTask!.deleteInBackground()
        PFUser.logOut()
    }
    
    func testPostTask(){
        task!
            .saveInBackgroundWithBlock { (succeeded, error) -> Void in
            
        }
        let query = PFQuery(className: "Task")
        query.whereKey("expiration", greaterThan: NSDate())
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            XCTAssert(objects!.contains(self.expiredTask!))
        }
    }
    
    func testPostExpiredTask(){
        expiredTask!.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            
        }
        let query = PFQuery(className: "Task")
        query.whereKey("expiration", greaterThan: NSDate())
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            XCTAssert(!objects!.contains(self.expiredTask!))
        }
        
    }
    func testDeleteTask(){
        
        task?.deleteInBackgroundWithBlock({ (succeed, error) -> Void in
            XCTAssert(succeed)
        })
    }
    
}
