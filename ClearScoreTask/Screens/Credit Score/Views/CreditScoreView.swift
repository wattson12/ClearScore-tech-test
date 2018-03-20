//
//  CreditScoreView.swift
//  ClearScoreTask
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit

final class CreditScoreView: BaseView {

    //internal state used to represent the possible view states
    //used to avoid needing to pass any specific model values to the view
    enum ViewState {
        case initial
        case loading
        case loaded(score: NSAttributedString, possibleTotal: NSAttributedString, progress: CGFloat)
        case error(error: NSAttributedString)
    }

    var viewState: ViewState = .initial {
        didSet {
            configureForCurrentViewState()
        }
    }

    private let outerBorderView = CircularBorderView(borderColor: .outerCircle)
    private let innerGradientView = GradientCircleView(colors: [.black, .red, .blue, .green])

    private let topLabel: UILabel = {
        let topLabel = UILabel()
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.textAlignment = .center
        topLabel.font = .creditScoreSupplementary
        topLabel.text = NSLocalizedString("credit_score_header", comment: "Header when showing credit score")
        return topLabel
    }()

    private let centerLabel: UILabel = {
        let centerLabel = UILabel()
        centerLabel.translatesAutoresizingMaskIntoConstraints = false
        centerLabel.textAlignment = .center
        centerLabel.font = .creditScore
        return centerLabel
    }()

    private let bottomLabel: UILabel = {
        let bottomLabel = UILabel()
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.textAlignment = .center
        bottomLabel.font = .creditScoreSupplementary
        return bottomLabel
    }()

    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.color = .loadingActivityIndicatorView
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()

    override init() {
        super.init()

        self.backgroundColor = .background

        self.addSubview(outerBorderView)
        self.addSubview(innerGradientView)
        self.addSubview(topLabel)
        self.addSubview(centerLabel)
        self.addSubview(bottomLabel)
        self.addSubview(activityIndicatorView)

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
            centerLabel.centerXAnchor.constraint(equalTo: outerBorderView.centerXAnchor),
            centerLabel.centerYAnchor.constraint(equalTo: outerBorderView.centerYAnchor),
            centerLabel.widthAnchor.constraint(lessThanOrEqualTo: outerBorderView.widthAnchor, multiplier: 0.8)
        ])

        //top and bottom labels are set above and below the credit score respectively
        NSLayoutConstraint.activate([
            topLabel.centerXAnchor.constraint(equalTo: outerBorderView.centerXAnchor),
            topLabel.widthAnchor.constraint(lessThanOrEqualTo: outerBorderView.widthAnchor, multiplier: 0.6),
            topLabel.bottomAnchor.constraint(equalTo: centerLabel.topAnchor, constant: -10),

            bottomLabel.centerXAnchor.constraint(equalTo: outerBorderView.centerXAnchor),
            bottomLabel.widthAnchor.constraint(lessThanOrEqualTo: outerBorderView.widthAnchor, multiplier: 0.6),
            bottomLabel.topAnchor.constraint(equalTo: centerLabel.bottomAnchor, constant: 10)
        ])

        //activity indicator view pinned to center as well
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: outerBorderView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: outerBorderView.centerYAnchor)
        ])
    }

    private func configureForCurrentViewState() {
        switch viewState {
        case .initial:
            //hide all views
            topLabel.isHidden = true
            centerLabel.isHidden = true
            bottomLabel.isHidden = true
            activityIndicatorView.stopAnimating()

        case .loading:
            topLabel.isHidden = true
            centerLabel.isHidden = true
            bottomLabel.isHidden = true

            activityIndicatorView.startAnimating()

        case .loaded(let scoreString, let possibleString, let progress):
            topLabel.isHidden = false
            centerLabel.isHidden = false
            bottomLabel.isHidden = false
            activityIndicatorView.stopAnimating()

            //then set loaded values
            centerLabel.attributedText = scoreString
            bottomLabel.attributedText = possibleString
            innerGradientView.setProgress(progress, animated: true)

        case .error(let errorString):
            topLabel.isHidden = true
            centerLabel.isHidden = false
            bottomLabel.isHidden = true
            activityIndicatorView.stopAnimating()

            centerLabel.attributedText = errorString
        }
    }
}
