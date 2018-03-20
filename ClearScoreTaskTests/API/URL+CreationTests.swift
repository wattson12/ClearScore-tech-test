//
//  URL+CreationTests.swift
//  ClearScoreTaskTests
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import XCTest
@testable import ClearScoreTask

class URL_CreationTests: XCTestCase {
    
    func testMockCreditURLValue() {
        let url = URL.mockCredit
        XCTAssertEqual(url.absoluteString, "https://5lfoiyb0b3.execute-api.us-west-2.amazonaws.com/prod/mockcredit/values")
    }
    
}
