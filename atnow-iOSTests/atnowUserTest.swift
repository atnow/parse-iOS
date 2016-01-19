//
//  atnowUserTest.swift
//  atnow-iOS
//
//  Created by Ben Ribovich on 1/19/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import XCTest
import Parse

class atnowUserTest: XCTestCase {
    let email = "testUser@dartmouth.edu"
    let password = "password"
    var user : PFUser?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        user = PFUser()
        user?.username=email
        user?.email = email
        user?.password = password
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        PFUser.currentUser()?.deleteInBackground()
    }
    
    func testCreate() {
        // Creates a user
        user!.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
            XCTAssert(succeed)

        })

    }

    func testLogin() {
        // Logs  a user in
        PFUser.logInWithUsernameInBackground(user!.email!, password: user!
            
            .password!, block: { (user, error) -> Void in

        })
        XCTAssert(PFUser.currentUser()?.email==email)
        
    }
    
}
