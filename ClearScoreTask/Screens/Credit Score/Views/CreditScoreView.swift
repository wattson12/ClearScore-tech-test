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
        case loaded(score: NSAttributedString, progress: CGFloat)
        case error(error: NSAttributedString)
    }

    var viewState: ViewState = .initial {
        didSet {
            configureForCurrentViewState()
        }
    }

    private let outerBorderView = CircularBorderView(borderColor: .outerCircle)
    private let innerGradientView = GradientCircleView(colors: [.black, .red, .blue, .green])

    private let creditScoreLabel: UILabel = {
        let creditScoreLabel = UILabel()
        creditScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        creditScoreLabel.textAlignment = .center
        return creditScoreLabel
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
        self.addSubview(creditScoreLabel)
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
            creditScoreLabel.centerXAnchor.constraint(equalTo: outerBorderView.centerXAnchor),
            creditScoreLabel.centerYAnchor.constraint(equalTo: outerBorderView.centerYAnchor),
            creditScoreLabel.widthAnchor.constraint(lessThanOrEqualTo: outerBorderView.widthAnchor, multiplier: 0.8)
        ])

        //activity indicator view pinned to center as well
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: outerBorderView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: outerBorderView.centerYAnchor)
        ])
    }

    private func configureForCurrentViewState() {
        switch viewState {
        case .initial: break //handled on initialisation

        case .loading:
            activityIndicatorView.startAnimating()
            creditScoreLabel.isHidden = true

        case .loaded(let scoreString, let progress):
            //remove spinner and restore view
            activityIndicatorView.stopAnimating()
            creditScoreLabel.isHidden = false

            //then set loaded values
            creditScoreLabel.attributedText = scoreString
            innerGradientView.setProgress(progress, animated: true)
            
        case .error:
            activityIndicatorView.stopAnimating()
            break //TODO: handling
        }
    }
}
