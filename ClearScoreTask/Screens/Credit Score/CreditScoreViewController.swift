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

//this is an abstraction around URLSession which will help testing view models
protocol DataProvider {
    func fetchData(fromURL url: URL) -> Observable<Data>
}

//URLSession is the easiest way, build on existing Rx extensions to add conformance
extension URLSession: DataProvider {

    func fetchData(fromURL url: URL) -> Observable<Data> {
        return self.rx.data(request: URLRequest(url: url))
    }
}

enum State<T> {
    case initial
    case loading
    case success(T)
    case error(Error)
}

final class CreditScoreViewModel {

    let disposeBag = DisposeBag()

    let dataProvider: DataProvider

    let creditReport: BehaviorRelay<State<CreditReportInfo>> = BehaviorRelay(value: .initial)

    init(dataProvider: DataProvider = URLSession.shared) {
        self.dataProvider = dataProvider
    }

    func fetchMovies() {

//        dataProvider
//            .fetchData(fromURL: .movieList)
//            .convertToAPIResult(holdingType: Movie.self)
//            .catchErrorJustReturn([]) //TODO: Nicer error handling
//            .bind(to: movies)
//            .disposed(by: disposeBag)
    }
}

class CreditScoreViewController: BaseViewController {

    private let viewModel: CreditScoreViewModel

    init(viewModel: CreditScoreViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func loadView() {
        self.view = CreditScoreView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }

    private func setupBindings() {
        
        viewModel
            .creditReport
            .subscribe(onNext: { state in
                print(state)
            })
            .disposed(by: disposeBag)
    }
}
