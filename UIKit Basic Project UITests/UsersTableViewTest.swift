//
//  UIKit_Basic_Project_UITests.swift
//  UIKit Basic Project UITests
//
//  Created by Mustafa B'irat on 14/06/2020.
//  Copyright © 2020 Mustafa Birat. All rights reserved.
//

import XCTest

class UsersTableViewTest: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
        app.launchArguments.append("--uitesting")
    }

    override func tearDown() {
        app = nil
    }

    func testUsersTableViewSwipeLeftToDelete() {
        let row = app.tables.firstMatch.staticTexts.firstMatch
        app.launch()
        row.swipeLeft()
        row.swipeLeft()
        XCTAssert(!app.tables.firstMatch.staticTexts["Bret"].exists)
    }
    
    func testUsersTableViewHittable() {
        let row1 = app.cells.element(boundBy: 1)
        app.launch()
        row1.tap()
        XCTAssert(app.navigationBars["User Details"].buttons["Users"].exists)
    }
    
    func testSearchBar() {
        app.launch()
        let usersNavigationBar = app.navigationBars["Users"]
        let searchUsersSearchField = usersNavigationBar.searchFields["Search Users"]
        searchUsersSearchField.tap()
        searchUsersSearchField.typeText("a")
        XCTAssert(app.cells.count == 1)
    }
}
