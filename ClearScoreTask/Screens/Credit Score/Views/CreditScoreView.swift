//
//  CreditScoreView.swift
//  ClearScoreTask
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit

final class CreditScoreView: BaseView {

    let outerBorderView = CircularBorderView(borderColor: .outerCircle)
    let innerGradientView = GradientCircleView(colors: [.black, .red, .blue, .green])

    let creditScoreLabel: UILabel = {
        let creditScoreLabel = UILabel()
        creditScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        creditScoreLabel.textAlignment = .center
        return creditScoreLabel
    }()

    override init() {
        super.init()

        self.backgroundColor = .background

        self.addSubview(outerBorderView)
        self.addSubview(innerGradientView)
        self.addSubview(creditScoreLabel)

        //outer view is centered in the screen, square (/circular once corner radius is applied), and within the size of the view
        NSLayoutConstraint.activate([
            outerBorderView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            outerBorderView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            outerBorderView.heightAnchor.constraint(equalTo: outerBorderView.widthAnchor),

            //add two sets of constraints relative to the super view: required to be less than 90% and low for equal to
            //this allows the outer view to resize relative to the view on rotation
            outerBorderView.widthAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).withPriority(.required),
            outerBorderView.heightAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.9).withPriority(.required),
            outerBorderView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).withPriority(.defaultLow),
            outerBorderView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 0.9).withPriority(.defaultLow)
        ])

        //inner gradient view is pinned just inside inner edges of outer circle
        NSLayoutConstraint.activate([
            innerGradientView.leadingAnchor.constraint(equalTo: outerBorderView.leadingAnchor, constant: 5),
            innerGradientView.topAnchor.constraint(equalTo: outerBorderView.topAnchor, constant: 5),
            innerGradientView.trailingAnchor.constraint(equalTo: outerBorderView.trailingAnchor, constant: -5),
            innerGradientView.bottomAnchor.constraint(equalTo: outerBorderView.bottomAnchor, constant: -5)
        ])

        //credit score label is kept in the center of the outer view
        NSLayoutConstraint.activate([
            creditScoreLabel.centerXAnchor.constraint(equalTo: outerBorderView.centerXAnchor),
            creditScoreLabel.centerYAnchor.constraint(equalTo: outerBorderView.centerYAnchor),
            creditScoreLabel.widthAnchor.constraint(lessThanOrEqualTo: outerBorderView.widthAnchor, multiplier: 0.8)
        ])
    }
}
