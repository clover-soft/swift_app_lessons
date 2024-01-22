//
//  AuthControllerUITest.swift
//  Lesson07UITests
//
//  Created by yakov on 22.01.2024.
//

import XCTest

final class AuthControllerUITest: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launch()
    }
    
    func testTransitionToTabBarController() {
        let webView = app.webViews.firstMatch
        XCTAssertTrue(webView.exists)
    }
}
