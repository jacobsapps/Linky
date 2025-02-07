//
//  ContactsCoordinator.swift
//  Linky
//
//  Created by Jacob Bartlett on 28/01/2025.
//

import UIKit
import Factory

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
        handleDeepLinks()
    }
    
    func start() {
        let vc = SwiftUIViewController(with: ContactsView())
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
        navigationController.viewControllers = [vc]
    }
    
    func handleDeepLinks() {
        Task {
            await withTaskGroup(of: Void.self) { [deepLink, weak self] in
                $0.addTask { @MainActor in
                    for await _ in deepLink.stream(.contacts) {
                        self?.navigate(to: .contacts)
                    }
                }
                $0.addTask { @MainActor in
                    for await _ in deepLink.stream(.addContact) {
                        self?.navigate(to: .addContact)
                    }
                }
            }
        }
//        Task { @MainActor in
//            for await link in deepLink.stream(.contacts, .addContact) {
//                switch link {
//                case .contacts:
//                    navigate(to: .contacts)
//                case .addContact:
//                    navigate(to: .addContact)
//                default:
//                    break
//                }
//            }
//        }
    }
    
    func navigate(to route: any Route) {
        guard let route = route as? ContactsRoute else { return }
        navigate(to: route)
    }
    
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
