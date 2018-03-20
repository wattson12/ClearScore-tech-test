//
//  DataProvider.swift
//  ClearScoreTask
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import Foundation
import RxSwift

//this is an abstraction around URLSession which will help testing view models
protocol DataProvider {
    func fetchData(fromURL url: URL) -> Observable<Data>
}

//URLSession is the easiest way, build on existing Rx extensions to add conformance
extension URLSession: DataProvider {

    func fetchData(fromURL url: URL) -> Observable<Data> {
        return self.rx.data(request: URLRequest(url: url))
    }
}

//helper to provide a default instance, which will help with mocking for UI tests
func defaultDataProvider(scenario: Testing.Scenario? = Testing.uiTestingScenario) -> DataProvider {
    guard let scenario = scenario else {
        return URLSession.shared
    }

    switch scenario {
    case .mockedFullResponse:
        return MockDataProviderFromFile(dataFileName: "full_response")
    case .mockedError:
        return FailingDataProvider(error: NSError(domain: #file, code: #line, userInfo: nil))
    case .indefiniteLoading:
        return NoOpDataProvider()
    }
}

//Data provider which never returns
struct NoOpDataProvider: DataProvider {

    func fetchData(fromURL url: URL) -> Observable<Data> {
        return .never()
    }
}

//data provider which returns data from the given file name
struct MockDataProviderFromFile: DataProvider {

    let dataFileName: String

    func fetchData(fromURL url: URL) -> Observable<Data> {
        guard let jsonPath = Bundle.main.path(forResource: dataFileName, ofType: "json") else {
            return .never()
        }

        guard let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            return .never()
        }

        return .just(data)
    }
}

//data provider which fails
struct FailingDataProvider: DataProvider {

    let error: Error

    func fetchData(fromURL url: URL) -> Observable<Data> {
        return .error(error)
    }
}
