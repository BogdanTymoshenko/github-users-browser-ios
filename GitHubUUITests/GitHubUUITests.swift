//
//  GitHubUUITests.swift
//  GitHubUUITests
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import XCTest

class GitHubUUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_userSearch_success() {
        let app = XCUIApplication()
        
        // Tap on the search input
        let searchFieldText = "Type user name/login/email"
        app.tables.searchFields[searchFieldText].tap()
        
        // Type query
        app.searchFields[searchFieldText].typeText("bogdantym")
        
        // Check user found
        app.tables.cells.containing(.staticText, identifier: "BogdanTymoshenko")
        
        // Open user repos
        app.tables.cells.staticTexts["BogdanTymoshenko"].tap()
        
        // Check current project repo shows
        app.collectionViews.cells.containing(.staticText, identifier: "github-users-browser-ios")
    }
}
