//
//  CreditScoreViewController.swift
//  ClearScoreTask
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreditScoreViewController: BaseViewController {

    private let viewModel: CreditScoreViewModel
    private let creditScoreView = CreditScoreView()

    init(viewModel: CreditScoreViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func loadView() {
        self.view = creditScoreView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.fetchCreditScore()
    }

    private func setupBindings() {

        //observe updates to credit report state in view model
        viewModel
            .creditReport
            .subscribe(onNext: { [unowned self] state in
                switch state {
                case .initial: break
                case .loading:
                    self.setViewToLoadingState()
                case .success(let creditReportInfo):
                    self.configureView(withCreditReportInfo: creditReportInfo)
                case .error(let error):
                    self.configureView(withError: error)
                }
            })
            .disposed(by: disposeBag)

        //bind view model title directly to navigation item title
        viewModel
            .title.asObservable()
            .map { NSLocalizedString($0, comment: "") }
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: disposeBag)
    }

    private func setViewToLoadingState() {
        creditScoreView.viewState = .loading
    }

    private func configureView(withCreditReportInfo creditReportInfo: CreditReportInfo) {

        let scoreString = NSAttributedString(string: creditReportInfo.score.description, attributes: [
            .foregroundColor: UIColor.creditScore
        ])
        let totalString = NSAttributedString(
            string: String(format: NSLocalizedString("total_possible_score_format", comment: "Format string when showing possible score"), arguments: [creditReportInfo.maxScoreValue])
        )
        let progress = CGFloat(creditReportInfo.score) / CGFloat(creditReportInfo.maxScoreValue - creditReportInfo.minScoreValue)

        creditScoreView.viewState = .loaded(
            score: scoreString,
            possibleTotal: totalString,
            progress: progress
        )
    }

    private func configureView(withError error: Error) {
        let errorString = NSAttributedString(string: NSLocalizedString("generic_error_message", comment: "Error message for all errors when fetching score"))
        creditScoreView.viewState = .error(error: errorString)
    }
}
