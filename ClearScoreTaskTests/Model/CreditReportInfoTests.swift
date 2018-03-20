//
//  CreditReportInfoTests.swift
//  ClearScoreTaskTests
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import XCTest
@testable import ClearScoreTask

func creditReportInfoData(withMissingField missingField: String, file: StaticString = #file, line: UInt = #line) -> Data {
    var json = [
        "score": 500,
        "minScoreValue": 1,
        "maxScoreValue": 642
    ]

    json[missingField] = nil

    guard let data = try? JSONSerialization.data(withJSONObject: json) else {
        XCTFail("Error creating data from JSON with missing field: \(json)", file: file, line: line)
        return Data()
    }

    return data
}

class CreditReportInfoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMappingCreditReportInfoFromValidData() {
        let data = testData(fromFixtureNamed: "credit_report_info")
        do {
            let creditReportInfo = try JSONDecoder().decode(CreditReportInfo.self, from: data)
            XCTAssertEqual(creditReportInfo.score, 514)
            XCTAssertEqual(creditReportInfo.minScoreValue, 0)
            XCTAssertEqual(creditReportInfo.maxScoreValue, 700)
        } catch {
            XCTFail("Unexpected error mapping CreditReportInfo: \(error)")
        }
    }

    func testMappingCreditReportFailsWhenRequiredFieldsAreMissing() {
        let requiredFields = ["score", "minScoreValue", "maxScoreValue"]
        for requiredField in requiredFields {
            let data = creditReportInfoData(withMissingField: requiredField)
            let creditReportInfo = try? JSONDecoder().decode(CreditReportInfo.self, from: data)
            XCTAssertNil(creditReportInfo)
        }
    }
    
}
