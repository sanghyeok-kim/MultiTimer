//
//  TimerFilteringCondition.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/25.
//

import Foundation

enum TimerFilteringCondition: Int, CaseIterable {
    case all
    case active
    
    var index: Int {
        return rawValue
    }
    
    // TODO: Localizing
    var title: String {
        switch self {
        case .all:
            return "all"
        case .active:
            return "active"
        }
    }
}
