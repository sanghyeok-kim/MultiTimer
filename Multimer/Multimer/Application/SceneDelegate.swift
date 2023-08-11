//
//  SceneDelegate.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/02.
//

import UIKit
import StoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var homeCoordinator: HomeCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        configureDefaultNavigationBarAppearance()
        
        let rootNavigationController = UINavigationController()
        homeCoordinator = DefaultHomeCoordinator(navigationController: rootNavigationController)
        homeCoordinator?.start()
        
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
        
        SKStoreReviewController.requestReviewInCurrentScene()
    }
}

private extension SceneDelegate {
    func configureDefaultNavigationBarAppearance() {
        UINavigationBar.appearance().barTintColor = .systemBackground
    }
}
