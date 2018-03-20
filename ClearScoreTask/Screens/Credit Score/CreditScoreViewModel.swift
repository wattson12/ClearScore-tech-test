//
//  CreditScoreViewModel.swift
//  ClearScoreTask
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class CreditScoreViewModel {

    let disposeBag = DisposeBag()

    let dataProvider: DataProvider

    let creditReport: BehaviorRelay<State<CreditReportInfo>> = BehaviorRelay(value: .initial)
    let title: BehaviorRelay<String> = BehaviorRelay(value: "credit_report_view_title")

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
