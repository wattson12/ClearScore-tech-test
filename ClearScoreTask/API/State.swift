//
//  State.swift
//  ClearScoreTask
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import Foundation
import RxSwift

//Simple enum to model loading state
enum State<T> {
    case initial
    case loading
    case success(T)
    case error(Error)
}

//and some helpers to move from an observable of a generic type, to a state of the same type
extension Observable {

    func wrapInState() -> Observable<State<Element>> {
        return self
            .map { State<Element>.success($0) }
            .catchError { error in return Observable<State<Element>>.just(.error(error)) }
    }
}
