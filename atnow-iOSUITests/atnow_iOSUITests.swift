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
    
    func testCreateTask() {
        
        let app = XCUIApplication()
        app.navigationBars["Current Tasks"].buttons["Compose"].tap()
        
        let descriptionTextField = app.textFields["Description"]
        descriptionTextField.tap()
        descriptionTextField.typeText("Test Task")
        
        let paymentAmountTextField = app.textFields["Payment amount ($)"]
        paymentAmountTextField.tap()
        paymentAmountTextField.tap()
        paymentAmountTextField.typeText("5")
        
        let deliveryLocationOptionalTextField = app.textFields["Delivery location (optional)"]
        deliveryLocationOptionalTextField.tap()
        deliveryLocationOptionalTextField.tap()
        deliveryLocationOptionalTextField.typeText("Test Location")
        app.datePickers.pickerWheels["Today"].tap()
        app.buttons["Submit"].tap()
        app.alerts["Success!"].collectionViews.buttons["OK"].tap()
   
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testDeleteTask(){
        
        let app = XCUIApplication()
        app.tabBars.buttons["My Tasks"].tap()
        app.tables.staticTexts["15d 23h 50m"].tap()
        app.buttons["Delete Task"].tap()
        app.alerts["Are you sure?"].collectionViews.buttons["OK"].tap()
        
    }
    
    func testLogoutFromProfile(){
        
        let app = XCUIApplication()
        app.navigationBars["My Tasks"].buttons["reveal icon"].tap()
        app.tables.containingType(.Image, identifier:"User Icon").element.tap()
        app.buttons["Sign Out"].tap()
        
    }
    
}
