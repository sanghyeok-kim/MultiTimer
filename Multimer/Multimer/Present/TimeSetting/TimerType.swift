//
//  TimerType.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/20.
//

import Foundation

@frozen
enum TimerType: Int, CaseIterable {
    case countDown
    case countUp
    
    var index: Int {
        return rawValue
    }
    
    // TODO: Localizing
    var title: String {
        switch self {
        case .countDown:
            return "⏳ 타이머 (카운트 다운)"
        case .countUp:
            return "⏱ 스톱워치 (카운트 업)"
        }
    }
    
    var shouldSetTime: Bool {
        switch self {
        case .countDown:
            return true
        case .countUp:
            return false
        }
    }
}
