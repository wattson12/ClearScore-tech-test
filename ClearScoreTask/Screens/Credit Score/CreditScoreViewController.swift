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

//TODO: remove this
extension UIColor {

    class var random: UIColor {

        let hue = ( Double(Double(arc4random()).truncatingRemainder(dividingBy: 256.0) ) / 256.0 )
        let saturation = ( (Double(arc4random()).truncatingRemainder(dividingBy: 128)) / 256.0 ) + 0.5
        let brightness = ( (Double(arc4random()).truncatingRemainder(dividingBy: 128)) / 256.0 ) + 0.5

        return UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1.0)
    }
}

//TODO: move this
extension NSLayoutConstraint {

    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}

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
                case .loading:
                    self.setViewToLoadingState()
                case .success(let creditReportInfo):
                    self.configureView(withCreditReportInfo: creditReportInfo)
                default:
                    break
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

        let scoreString = NSAttributedString(string: creditReportInfo.score.description)
        let progress = CGFloat(creditReportInfo.score) / CGFloat(creditReportInfo.maxScoreValue - creditReportInfo.minScoreValue)

        creditScoreView.viewState = .loaded(score: scoreString, progress: progress)
    }
}
