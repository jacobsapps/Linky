//
//  RecentsCoordinator.swift
//  Linky
//
//  Created by Jacob Bartlett on 28/01/2025.
//

import AsyncAlgorithms
import Factory
import UIKit

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
        Task { await handleDeepLinks() }
    }
    
    func start() {
        let vc = SwiftUIViewController(with: RecentsView())
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 1)
        navigationController.viewControllers = [vc]
    }
    
    func handleDeepLinks() async {
        for await link in merge(deepLink.stream(.recents),
                                deepLink.stream(.mostRecent)) {
            switch link {
            case .recents:
                await navigate(to: .recents)
            case .mostRecent:
                await navigate(to: .mostRecent)
            default:
                break
            }
        }
    }
    
    func navigate(to route: Route) {
        guard let route = route as? RecentsRoute else { return }
        navigate(to: route)
    }
    
    @MainActor
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
