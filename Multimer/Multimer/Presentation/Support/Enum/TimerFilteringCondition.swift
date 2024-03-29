//
//  TimerFilteringCondition.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/25.
//

import Foundation

@frozen
enum TimerFilteringCondition: Int, CaseIterable {
    case all
    case active
    
    var index: Int {
        return rawValue
    }
    
    var title: String {
        switch self {
        case .all:
            return LocalizableString.all.localized
        case .active:
            return LocalizableString.activated.localized
        }
    }
}
