//
//  atnow_iOSUITests.swift
//  atnow-iOSUITests
//
//  Created by Benjamin Holland on 1/20/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import XCTest
import Parse
import ParseUI
@testable import atnow_iOS

class atnow_iOSUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        PFUser.logOut()
        
        
        let app = XCUIApplication()
        let dartmouthEduEmailTextField = app.textFields["dartmouth.edu email"]
        dartmouthEduEmailTextField.tap()
        dartmouthEduEmailTextField.typeText("bh.16@dartmouth.edu")
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        app.buttons["Login"].tap()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUserLogin() {
        
        
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
