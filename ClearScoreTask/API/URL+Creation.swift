//
//  URL+Creation.swift
//  ClearScoreTask
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import Foundation

extension URL {

    static var mockCredit: URL {
        guard let mockCreditURL = URL(string: "https://5lfoiyb0b3.execute-api.us-west-2.amazonaws.com/prod/mockcredit/values") else {
            fatalError("Error creating url from hard coded url string for mock credit")
        }

        return mockCreditURL
    }
}
