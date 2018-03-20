//
//  UIColor+Styles.swift
//  ClearScoreTask
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit

//This could be broken down by screen, state etc but for this amount of colours I'm leaving it in one extension
extension UIColor {

    static var background: UIColor {
        return .white
    }

    static var creditScoreSupplementary: UIColor {
        return .darkText
    }

    static var creditScore: UIColor {
        return .random
    }

    static var outerCircle: UIColor {
        return UIColor(red: 0.298, green: 0.298, blue: 0.298, alpha: 1)
    }

    static var innerCircle: UIColor {
        return .random
    }

    static var navBarBackground: UIColor {
        return .black
    }

    static var navBarTitle: UIColor {
        return .white
    }
}
