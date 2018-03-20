//
//  CreditScoreViewController.swift
//  ClearScoreTask
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit

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

final class CreditScoreView: BaseView {

    let outerBorderView = CircularBorderView(borderColor: .black)

    let creditScoreLabel: UILabel = {
        let creditScoreLabel = UILabel()
        creditScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        creditScoreLabel.textAlignment = .center
        creditScoreLabel.text = "500"
        return creditScoreLabel
    }()

    override init() {
        super.init()

        self.backgroundColor = .random

        self.addSubview(outerBorderView)
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

        //credit score label is kept in the center of the outer view
        NSLayoutConstraint.activate([
            creditScoreLabel.centerXAnchor.constraint(equalTo: outerBorderView.centerXAnchor),
            creditScoreLabel.centerYAnchor.constraint(equalTo: outerBorderView.centerYAnchor),
            creditScoreLabel.widthAnchor.constraint(lessThanOrEqualTo: outerBorderView.widthAnchor, multiplier: 0.8)
        ])
    }
}

class CreditScoreViewController: BaseViewController {

    override func loadView() {
        self.view = CreditScoreView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
