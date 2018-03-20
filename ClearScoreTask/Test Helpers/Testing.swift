//
//  Testing.swift
//  ClearScoreTask
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import Foundation

//empty enum used for namespacing only
enum Testing { }

extension Testing {

    private static func launchArgumentsContains(_ argument: String) -> Bool {
        return ProcessInfo.processInfo.arguments.contains(argument)
    }

    static var isUITestingActive: Bool {
        return launchArgumentsContains("ui_testing_active")
    }

    //possible testing scenarios
    //this is a fairly rough way of communicating with the UI test app, mainly used to get something up and running quickly for this tech test
    enum Scenario {
        case mockedFullResponse
        case mockedError
        case indefiniteLoading
    }

    static var uiTestingScenario: Scenario? {
        guard isUITestingActive else { return nil }

        if launchArgumentsContains("ui_testing_scenario_mocked_error") {
            return .mockedError
        } else if launchArgumentsContains("ui_testing_scenario_indefinite_loading") {
            return .indefiniteLoading
        } else {
            return .mockedFullResponse //default to mocking a full response if possible
        }
    }
}
