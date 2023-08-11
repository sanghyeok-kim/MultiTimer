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
        notificationIdentifier: String
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
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    static func removeNotification(withIdentifiers identifiers: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    static func updateRingtone(for notificationIdentifier: String, remainingSeconds: Double, newRingtone: Ringtone?) {
        let center = UNUserNotificationCenter.current()
        
        center.getPendingNotificationRequests { requests in
            guard let matchingRequest = requests.first(where: { $0.identifier == notificationIdentifier }) else { return }
            guard let updatedContent = matchingRequest.content.mutableCopy() as? UNMutableNotificationContent else { return }
            
            if let ringtoneFileName = newRingtone?.name, newRingtone != .default1 {
                updatedContent.sound = UNNotificationSound(
                    named: UNNotificationSoundName(rawValue: "\(ringtoneFileName).\(Constant.Ringtone.extension)")
                )
            }
            
            let updatedTrigger = UNTimeIntervalNotificationTrigger(timeInterval: remainingSeconds, repeats: false)
            let updatedRequest = UNNotificationRequest(
                identifier: notificationIdentifier,
                content: updatedContent,
                trigger: updatedTrigger
            )
            
            center.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
            center.add(updatedRequest)
        }
    }
}
