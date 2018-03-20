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

extension UIColor {

    class var random: UIColor {

        let hue = ( Double(Double(arc4random()).truncatingRemainder(dividingBy: 256.0) ) / 256.0 )
        let saturation = ( (Double(arc4random()).truncatingRemainder(dividingBy: 128)) / 256.0 ) + 0.5
        let brightness = ( (Double(arc4random()).truncatingRemainder(dividingBy: 128)) / 256.0 ) + 0.5

        return UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1.0)
    }
}

extension NSLayoutConstraint {

    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}

final class CreditScoreViewModel {

    let disposeBag = DisposeBag()

    let dataProvider: DataProvider

    let creditReport: BehaviorRelay<State<CreditReportInfo>> = BehaviorRelay(value: .initial)

    init(dataProvider: DataProvider = URLSession.shared) {
        self.dataProvider = dataProvider
    }

    func fetchCreditScore() {
        creditReport.accept(.loading)

        dataProvider
            .fetchData(fromURL: .mockCredit)
            .convertToCreditReportInfo()
            .wrapInState() //convert to a state type so we can bind to the credit report relay
            .observeOn(MainScheduler.instance) //UI triggers are based off of the creditReport relay so move back to main thread here
            .bind(to: creditReport)
            .disposed(by: disposeBag)
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

        viewModel
            .creditReport
            .subscribe(onNext: { [unowned self] state in
                switch state {
                case .success(let creditReportInfo):
                    self.configureView(withCreditReportInfo: creditReportInfo)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    private func configureView(withCreditReportInfo creditReportInfo: CreditReportInfo) {
        creditScoreView.creditScoreLabel.text = creditReportInfo.score.description
    }
}
