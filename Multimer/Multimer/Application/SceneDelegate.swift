//
//  SceneDelegate.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/02.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let initialViewController = MainViewController()
        let navVC = UINavigationController(rootViewController: initialViewController)
        let viewModel = MainViewModel(
            mainUseCase: MainUseCase(
                mainRepository: MainRepository()
            )
        )
        initialViewController.bind(viewModel: viewModel)
//        let initialViewController = TimerSettingViewController()
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
//        window?.rootViewController = initialViewController
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
}
