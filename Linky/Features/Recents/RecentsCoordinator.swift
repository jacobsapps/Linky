//
//  RecentsCoordinator.swift
//  Linky
//
//  Created by Jacob Bartlett on 28/01/2025.
//

import UIKit
import Factory

final class RecentsCoordinator: Coordinator {
    @Injected(\.deepLinkHandler) private var deepLink
    
    enum RecentsRoute: Route {
        case recents
        case mostRecent
    }
    
    weak var parent: Coordinator?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, parent: Coordinator?) {
        self.navigationController = navigationController
        self.parent = parent
        handleDeepLinks()
    }
    
    func start() {
        let vc = SwiftUIViewController(with: RecentsView())
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 1)
        navigationController.viewControllers = [vc]
    }
    
    func handleDeepLinks() {
        Task { @MainActor in
            await withTaskGroup(of: Void.self) { [deepLink, weak self] in
                $0.addTask { @MainActor in
                    for await _ in deepLink.stream(.recents) {
                        self?.navigate(to: .recents)
                    }
                }
                $0.addTask { @MainActor in
                    for await _ in deepLink.stream(.mostRecent) {
                        self?.navigate(to: .mostRecent)
                    }
                }
            }
        }
//        Task { @MainActor in
//            for await link in deepLink.stream(.recents, .mostRecent) {
//                switch link {
//                case .recents:
//                    navigate(to: .recents)
//                case .mostRecent:
//                    navigate(to: .mostRecent)
//                default:
//                    break
//                }
//            }
//        }
    }
    
    func navigate(to route: Route) {
        guard let route = route as? RecentsRoute else { return }
        navigate(to: route)
    }
    
    func navigate(to route: RecentsRoute) {
        parent?.navigate(to: AppCoordinator.AppRoute.recents)
        
        switch route {
        case .recents:
            break
            
        case .mostRecent:
            let vc = SwiftUIViewController(with: MostRecentView())
            navigationController.pushViewController(vc, animated: true)
        }
    }
}
