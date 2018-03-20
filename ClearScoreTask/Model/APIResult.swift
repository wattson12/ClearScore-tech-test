//
//  APIResult.swift
//  ClearScoreTask
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import Foundation

//Wrapper for the full API response, making it easier to parse / decode the credit report info
struct APIResult: Decodable {
    let creditReportInfo: CreditReportInfo
}
