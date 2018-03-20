//
//  Coordinator.swift
//  ClearScoreTask
//
//  Created by Sam Watts on 20/03/2018.
//  Copyright © 2018 Sam Watts. All rights reserved.
//

import Foundation

//This protocol is used to represent the coordinators which control navigation around the app
//The are responsible for creating and presenting view controllers, and handling updates from VCs (via delegates)
//Each view controller should not know how it was presented, or how another view controller is created or presented
protocol Coordinator {
    func start()
    var childCoordinators: [Coordinator] { get }
}
