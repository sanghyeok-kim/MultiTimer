//
//  RingtoneType.swift
//  Multimer
//
//  Created by 김상혁 on 2023/08/02.
//

import Foundation

enum RingtoneType: String, CaseIterable {
    case alertTone
    case ringtone
    
    var title: String {
        switch self {
        case .alertTone:
            return LocalizableString.alertTones.localized
        case .ringtone:
            return LocalizableString.ringtones.localized
        }
    }
}
