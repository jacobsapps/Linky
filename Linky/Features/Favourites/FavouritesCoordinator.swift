//
//  FavouritesCoordinator.swift
//  Linky
//
//  Created by Jacob Bartlett on 28/01/2025.
//

import UIKit
import Factory

final class FavouritesCoordinator: Coordinator {
    @Injected(\.deepLinkHandler) private var deepLink
    
    enum FavouritesRoute: Route {
        case favourites
    }
    
    weak var parent: Coordinator?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, parent: Coordinator?) {
        self.navigationController = navigationController
        self.parent = parent
        handleDeepLinks()
    }
    
    func start() {
        let vc = SwiftUIViewController(with: FavouritesView())
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        navigationController.viewControllers = [vc]
    }
    
    func handleDeepLinks() {
        Task {
            await withTaskGroup(of: Void.self) { [deepLink, weak self] in
                $0.addTask { @MainActor in
                    for await _ in deepLink.stream(.favourites) {
                        self?.navigate(to: .favourites)
                    }
                }
            }
        }
//        Task { @MainActor in
//            for await link in deepLink.stream(.favourites) {
//                switch link {
//                case .favourites:
//                    navigate(to: .favourites)
//                default:
//                    break
//                }
//            }
//        }
    }
    
    func navigate(to route: any Route) {
        guard let route = route as? FavouritesRoute else { return }
        navigate(to: route)
    }
    
    func navigate(to route: FavouritesRoute) {
        parent?.navigate(to: AppCoordinator.AppRoute.favourites)
        
        switch route {
        case .favourites:
            break 
        }
    }
}
