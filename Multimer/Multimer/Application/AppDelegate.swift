//
//  AppDelegate.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/02.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UIApplication.shared.isIdleTimerDisabled = true
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
        { [weak self] (didAllow, error) in
            UNUserNotificationCenter.current().delegate = self
            self?.setNotificationAuthAlertPreference(didAllow: didAllow)
            self?.postNotificationIfFirstLaunch()
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
    
    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // foreground에서 실행중일 때 local notification이 전달시 이 메소드가 실행
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}

// MARK: - Supporting Methods

private extension AppDelegate {
    func setNotificationAuthAlertPreference(didAllow: Bool) {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: Constant.UserDefaultsKey.isFirstLaunch)
        let shouldShowNotificationAuthAlert = !isFirstLaunch && !didAllow
        UserDefaults.standard.set(shouldShowNotificationAuthAlert, forKey: Constant.UserDefaultsKey.isNotificationAllowed)
    }
    
    func postNotificationIfFirstLaunch() {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: Constant.UserDefaultsKey.isFirstLaunch)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: Constant.UserDefaultsKey.isFirstLaunch)
            NotificationCenter.default.post(
                name: .showSwipeToStopNotice,
                object: nil,
                userInfo: nil
            )
        }
    }
}
