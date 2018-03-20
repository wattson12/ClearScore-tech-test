//
//  AppCoordinator.swift
//  ClearScoreTask
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {

    //save a reference to the window so that the view hierarchy can be traversed while handling view controller presentation
    //could just as easily save the navigation controller in this example since that is the most useful starting point
    private let window: UIWindow

    //Note: for this app I am not using any child coordinators, but have put this here to show how this pattern can be managed as the app grows
    //A child coordinator can be added when a different flow is entered (e.g. a login modal flow, or onboarding / tutorial view is started)
    let childCoordinators: [Coordinator] = []

    init(withWindow window: UIWindow) {
        self.window = window
    }

    func start() {
        let creditScoreViewController = CreditScoreViewController()
        let rootNavigationController = UINavigationController(rootViewController: creditScoreViewController)

        window.rootViewController = rootNavigationController
        window.backgroundColor = .white

        window.makeKeyAndVisible()
    }
}
