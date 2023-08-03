//
//  UserNotificationCenterService.swift
//  Multimer
//
//  Created by 김상혁 on 2023/08/02.
//

import Foundation
import UserNotifications

final class UserNotificationCenterService {
    static func registerNotification(
        ringtone: Ringtone?,
        remainingSeconds: TimeInterval,
        timerName: String,
        notificationIdentifier: String?
    ) {
        let content = UNMutableNotificationContent()
        content.title = LocalizableString.appTitle.localized
        content.body = LocalizableString.timerExpired(timerName: timerName).localized
        content.sound = .default
        
        if let ringtoneFileName = ringtone?.name, ringtone != .default1 {
            content.sound = UNNotificationSound(
                named: UNNotificationSoundName(rawValue: "\(ringtoneFileName).\(Constant.Ringtone.extension)")
            )
        }
        
        if remainingSeconds <= .zero { return }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: remainingSeconds, repeats: false)
        guard let notificationIdentifier = notificationIdentifier else { return }
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    static func removeNotification(withIdentifiers identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
