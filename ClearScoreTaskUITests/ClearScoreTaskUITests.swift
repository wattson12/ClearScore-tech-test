//
//  ClearScoreTaskUITests.swift
//  ClearScoreTaskUITests
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import XCTest

class ClearScoreTaskUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments += ["ui_testing_active"]
    }
    
    func testCreditScoreIsShownWithCorrectAdditionalInfo() {
        app.launch()

        XCTAssertTrue(app.staticTexts["Your credit score is"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.staticTexts["514"].waitForExistence(timeout: 0.5))
        XCTAssertTrue(app.staticTexts["out of 700"].waitForExistence(timeout: 0.5))
    }

    func testErrorMessageIsShownOnFailure() {
        app.launchArguments += ["ui_testing_scenario_mocked_error"]
        app.launch()

        XCTAssertTrue(app.staticTexts["Unknown error :("].waitForExistence(timeout: 0.5))
    }

    func testLoadingStateIsShownWhileWaitingForResponse() {
        app.launchArguments += ["ui_testing_scenario_indefinite_loading"]
        app.launch()

        XCTAssertTrue(app.activityIndicators["loading_indicator"].waitForExistence(timeout: 0.5))
    }
    
}
