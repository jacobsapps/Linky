//
//  Coordinator.swift
//  Linky
//
//  Created by Jacob Bartlett on 28/01/2025.
//

import UIKit

protocol Coordinator: AnyObject {
    var parent: Coordinator? { get }
    var navigationController: UINavigationController { get set }
    func start()
    func navigate(to route: Route)
    func handleDeepLinks()
}

protocol Route {}
