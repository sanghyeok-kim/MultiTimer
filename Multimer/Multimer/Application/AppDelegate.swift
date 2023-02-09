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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.isIdleTimerDisabled = true
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (didAllow, error) in
            switch didAllow {
            case true:
                UNUserNotificationCenter.current().delegate = self
            case false:
                //TODO: 알람 울리지 않음 경고 출력
                break
            }
            
            let isFirstRun = !UserDefaults.standard.bool(forKey: Constant.UserDefaultsKey.isFirstRun)
            
            switch isFirstRun {
            case true:
                UserDefaults.standard.set(true, forKey: Constant.UserDefaultsKey.isFirstRun)
                NotificationCenter.default.post(name: .showSwipeToStopNotice, object: nil, userInfo: nil)
            case false:
                break
            }
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
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
