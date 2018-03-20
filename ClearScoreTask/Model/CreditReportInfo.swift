//
//  CreditReportInfo.swift
//  ClearScoreTask
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import Foundation

//Modelling only a small subset of the report info
struct CreditReportInfo: Decodable {
    let score: Int
    let minScoreValue: Int
    let maxScoreValue: Int
}
