//
//  APIResultTests.swift
//  ClearScoreTaskTests
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import XCTest
@testable import ClearScoreTask

class APIResultTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMappingFullResponseSucceeds() {
        let data = testData(fromFixtureNamed: "full_api_response")
        do {
            let apiResult = try JSONDecoder().decode(APIResult.self, from: data)
            XCTAssertEqual(apiResult.creditReportInfo.score, 514)
            XCTAssertEqual(apiResult.creditReportInfo.minScoreValue, 0)
            XCTAssertEqual(apiResult.creditReportInfo.maxScoreValue, 700)
        } catch {
            XCTFail("Unexpected error mapping CreditReportInfo: \(error)")
        }
    }
    
}
