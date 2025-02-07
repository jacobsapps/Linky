//
//  SceneDelegate.swift
//  Linky
//
//  Created by Jacob Bartlett on 27/01/2025.
//

import UIKit
import Factory

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    @Injected(\.deepLinkHandler) private var deepLink
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator?.start()
        
        if let urlContext = connectionOptions.urlContexts.first {
            print("Cold launch handling URL: \(urlContext.url)")
            deepLink.open(url: urlContext.url)
        }
    }
    
    // Opening a URL while the app is active or backgrounded
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let urlContext = URLContexts.first else { return }
        deepLink.open(url: urlContext.url)
    }
    
    // Called when opening via universal links
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard let url = userActivity.webpageURL else { return }
        deepLink.open(url: url)
    }
}
