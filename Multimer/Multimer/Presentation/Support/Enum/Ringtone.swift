//
//  Ringtone.swift
//  Multimer
//
//  Created by 김상혁 on 2023/07/30.
//

import Foundation

enum Ringtone: String, CaseIterable, Hashable {
    case alarm
    case bark
    case beacon
    case bulletin
    case default1
    case default2
    case default3
    case default4
    case default5
    case default6
    case default7
    case default8
    case duck
    case illuminate
    case marimba
    case oldPhone
    case pianoRiff
    case pinball
    case presto
    case radar
    case reflection
    case sencha
    case signal
    case stargaze
    case strum
    case trill
    case xylophone
    
    var name: String {
        return rawValue
    }
    
    var type: RingtoneType {
        switch self {
        case .default1, .default2, .default3, .default4, .default5, .default6, .default7, .default8:
            return .alertTone
        default:
            return .ringtone
        }
    }
}
