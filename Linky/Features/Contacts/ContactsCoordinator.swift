//
//  ContactsCoordinator.swift
//  Linky
//
//  Created by Jacob Bartlett on 28/01/2025.
//

import AsyncAlgorithms
import Factory
import UIKit

final class ContactsCoordinator: Coordinator {
    @Injected(\.deepLinkHandler) private var deepLink
    
    enum ContactsRoute: Route {
        case contacts
        case addContact
    }
    
    weak var parent: Coordinator?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, parent: Coordinator?) {
        self.navigationController = navigationController
        self.parent = parent
        Task { await handleDeepLinks() }
    }
    
    func start() {
        let vc = SwiftUIViewController(with: ContactsView())
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
        navigationController.viewControllers = [vc]
    }
    
    func handleDeepLinks() async {
        for await link in merge(deepLink.stream(.contacts),
                                deepLink.stream(.addContact)) {
            switch link {
            case .contacts:
                await navigate(to: .contacts)
            case .addContact:
                await navigate(to: .addContact)
            default:
                break
            }
        }
    }
    
    func navigate(to route: any Route) {
        guard let route = route as? ContactsRoute else { return }
        navigate(to: route)
    }
    
    @MainActor
    func navigate(to route: ContactsRoute) {

        parent?.navigate(to: AppCoordinator.AppRoute.contacts)

        switch route {
        case .contacts:
            break
            
        case .addContact:
            let vc = SwiftUIViewController(with: AddContactView())
            navigationController.present(vc, animated: true)
        }
    }
}
