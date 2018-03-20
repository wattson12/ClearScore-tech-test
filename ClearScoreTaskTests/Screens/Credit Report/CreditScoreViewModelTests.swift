//
//  CreditScoreViewModelTests.swift
//  ClearScoreTaskTests
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import XCTest
@testable import ClearScoreTask
import RxSwift
import RxCocoa

struct MockDataProvider: DataProvider {

    let data: Data

    func fetchData(fromURL url: URL) -> Observable<Data> {
        return .just(data)
    }
}

class CreditScoreViewModelTests: XCTestCase {

    let disposeBag = DisposeBag()

    func testInitialStateIsCorrect() {
        let viewModel = CreditScoreViewModel(dataProvider: NoOpDataProvider())
        let initialValue = viewModel.creditReport.value
        switch initialValue {
        case .initial:
            break
        default:
            XCTFail("Unexpected initial state: \(initialValue)")
        }
    }

    func testFetchingCreditScoreMovesIntoTheLoadingState() {
        let viewModel = CreditScoreViewModel(dataProvider: NoOpDataProvider())
        viewModel.fetchCreditScore()

        let currentValue = viewModel.creditReport.value
        switch currentValue {
        case .loading:
            break
        default:
            XCTFail("Unexpected value: \(currentValue)")
        }
    }

    func testSuccessfulDataLoadMovesToSuccessStateWithAssociatedValue() {
        let viewModel = CreditScoreViewModel(dataProvider: MockDataProvider(data: testData(fromFixtureNamed: "full_api_response")))

        let successStateReached = expectation(description: "reached success state")
        viewModel
            .creditReport
            .subscribe(onNext: { state in
                switch state {
                case .success(let value):
                    XCTAssertEqual(value.score, 514)
                    successStateReached.fulfill()
                case .initial, .loading:
                    break
                case .error(let error):
                    XCTFail("Unexpected error: \(error)")
                }
            })
            .disposed(by: disposeBag)

        viewModel.fetchCreditScore()

        waitForExpectations(timeout: 0.05)
    }

    func testFailedLoadMovesToErrorState() {
        let originalError = NSError(domain: #file, code: #line, userInfo: nil)
        let viewModel = CreditScoreViewModel(dataProvider: FailingDataProvider(error: originalError))

        let errorStateReached = expectation(description: "reached error state")
        viewModel
            .creditReport
            .subscribe(onNext: { state in
                switch state {
                case .error(let error as NSError):
                    XCTAssertEqual(error, originalError)
                    errorStateReached.fulfill()
                case .success(let value):
                    XCTFail("Unexpected success state with value: \(value)")
                case .initial, .loading:
                    break
                }
            })
            .disposed(by: disposeBag)

        viewModel.fetchCreditScore()

        waitForExpectations(timeout: 0.5)
    }

    func testTitleUsesTheCorrectLocalizedStringKey() {
        let viewModel = CreditScoreViewModel(dataProvider: NoOpDataProvider())
        let titleKey = viewModel.title.value
        XCTAssertEqual(titleKey, "credit_report_view_title")
    }
    
}
