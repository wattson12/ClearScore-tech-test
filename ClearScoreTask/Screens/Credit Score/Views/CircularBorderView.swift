//
//  CircularBorderView.swift
//  ClearScoreTask
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit

final class CircularBorderView: BaseView {

    @available(iOS, unavailable, message: "init() is unavailable, use init(borderColor:borderWidth:) instead")
    override init() { fatalError() }

    init(borderColor: UIColor, borderWidth: CGFloat = 1) {
        super.init()

        self.translatesAutoresizingMaskIntoConstraints = false

        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.bounds.width / 2
    }
}
