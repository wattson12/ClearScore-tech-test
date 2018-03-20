//
//  StateTests.swift
//  ClearScoreTaskTests
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import XCTest
@testable import ClearScoreTask
import RxSwift

class StateTests: XCTestCase {

    let disposeBag = DisposeBag()
    
    func testSuccessfulObservableIsConvertedToSuccessState() {

        let chainCompleted = expectation(description: "chain completed")

        Observable
            .just(1)
            .wrapInState()
            .subscribe { event in
                switch event {
                case .next(let state):
                    switch state {
                    case .success(let value):
                        XCTAssertEqual(value, 1)
                    default:
                        XCTFail("Unexpected state: \(state)")
                    }
                case .error(let error):
                    XCTFail("Unexpected error: \(error)")
                case .completed:
                    chainCompleted.fulfill()
                }
            }
            .disposed(by: disposeBag)

        waitForExpectations(timeout: 0.05)
    }

    func testErroredObservableIsConvertedToErrorState() {

        let chainCompleted = expectation(description: "chain completed")

        let originalError = NSError(domain: #file, code: #line, userInfo: nil)
        Observable<Int>
            .error(originalError)
            .wrapInState()
            .subscribe { event in
                switch event {
                case .next(let state):
                    switch state {
                    case .error(let error as NSError):
                        XCTAssertEqual(error, originalError)
                    default:
                        XCTFail("Unexpected state: \(state)")
                    }
                case .error(let error):
                    XCTFail("Unexpected error: \(error)") //we expect an error state, but not for the observable to error
                case .completed:
                    chainCompleted.fulfill()
                }
            }
            .disposed(by: disposeBag)

        waitForExpectations(timeout: 0.05)
    }
    
}
