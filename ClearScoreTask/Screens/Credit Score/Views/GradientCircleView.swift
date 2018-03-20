//
//  GradientCircleView.swift
//  ClearScoreTask
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit

final class GradientCircleView: BaseView {

    @available(iOS, unavailable, message: "init() is unavailable, use init(colors:lineWidth:) instead")
    override init() { fatalError() }

    let gradientMask = CAShapeLayer()
    let gradientLayer = CAGradientLayer()

    init(colors: [UIColor], lineWidth: CGFloat = 5) {
        super.init()

        self.translatesAutoresizingMaskIntoConstraints = false

        gradientMask.fillColor = UIColor.clear.cgColor
        gradientMask.strokeColor = UIColor.black.cgColor
        gradientMask.lineWidth = lineWidth
        gradientMask.strokeEnd = 0 //start with no gradient shown

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)

        gradientLayer.colors = colors.map { $0.cgColor }

        gradientLayer.mask = gradientMask
        self.layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientMask.frame = self.bounds
        gradientLayer.frame = self.bounds

        let path = CGMutablePath()
        path.addRelativeArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: (bounds.width - gradientMask.lineWidth) / 2, startAngle: -.pi / 2, delta: 2 * .pi)
        gradientMask.path = path
    }

    func setProgress(_ progress: CGFloat, animated: Bool = false) {
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = gradientMask.strokeEnd
            animation.fillMode = kCAFillModeForwards

            //maintain a consistent speed by adjusting duration based on magnitude of strokeEnd change
            let distance = abs(gradientMask.strokeEnd - progress)
            let duration = distance * 1

            animation.duration = CFTimeInterval(duration)

            gradientMask.strokeEnd = progress

            gradientMask.add(animation, forKey: "animateProgressChange")

        } else {
            //set directly (not strictly done without animation because CALayers have an implicit animation by default)
            gradientMask.strokeEnd = progress
        }
    }
}
