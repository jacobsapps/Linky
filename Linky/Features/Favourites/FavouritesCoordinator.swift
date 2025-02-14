//
//  FavouritesCoordinator.swift
//  Linky
//
//  Created by Jacob Bartlett on 28/01/2025.
//

import Factory
import UIKit

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
        Task { await handleDeepLinks() }
    }
    
    func start() {
        let vc = SwiftUIViewController(with: FavouritesView())
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        navigationController.viewControllers = [vc]
    }
    
    func handleDeepLinks() async {
        for await link in deepLink.stream(.favourites) {
            switch link {
            case .favourites:
                await navigate(to: .favourites)
            default:
                break
            }
        }
    }
    
    func navigate(to route: any Route) {
        guard let route = route as? FavouritesRoute else { return }
        navigate(to: route)
    }
    
    @MainActor
    private func navigate(to route: FavouritesRoute) {
        parent?.navigate(to: AppCoordinator.AppRoute.favourites)
        
        switch route {
        case .favourites:
            break 
        }
    }
}
