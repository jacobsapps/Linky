//
//  AppCoordinator.swift
//  Linky
//
//  Created by Jacob Bartlett on 28/01/2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    enum AppRoute: Route {
        case favourites
        case recents
        case contacts
    }
    
    weak var parent: Coordinator? = nil
    var navigationController =  UINavigationController()
    var window: UIWindow
    var tabBarController: UITabBarController
    var favouritesCoordinator: FavouritesCoordinator?
    var recentsCoordinator: RecentsCoordinator?
    var contactsCoordinator: ContactsCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let favouritesNav = UINavigationController()
        let recentsNav = UINavigationController()
        let contactsNav = UINavigationController()
        
        favouritesCoordinator = FavouritesCoordinator(navigationController: favouritesNav, parent: self)
        recentsCoordinator = RecentsCoordinator(navigationController: recentsNav, parent: self)
        contactsCoordinator = ContactsCoordinator(navigationController: contactsNav, parent: self)
        
        favouritesCoordinator?.start()
        recentsCoordinator?.start()
        contactsCoordinator?.start()
        
        tabBarController.viewControllers = [favouritesNav, recentsNav, contactsNav]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    func navigate(to route: any Route) {
        guard let route = route as? AppRoute else { return }
        navigate(to: route)
    }
    
    func navigate(to route: AppRoute) {
        switch route {
        case .favourites:
            tabBarController.selectedIndex = 0
        case .recents:
            tabBarController.selectedIndex = 1
        case .contacts:
            tabBarController.selectedIndex = 2
        }
    }
    
    func handleDeepLinks() async { }
}
