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
    
    var title: String {
        switch self {
        case .countDown:
            return LocalizableString.timer.localized
        case .countUp:
            return LocalizableString.stopwatch.localized
        }
    }
    
    var name: String {
        switch self {
        case .countDown:
            return LocalizableString.countDownTimer.localized
        case .countUp:
            return LocalizableString.countUpStopwatch.localized
        }
    }
    
    var placeholder: String {
        switch self {
        case .countDown:
            return LocalizableString.enterTimerNameToCreate.localized
        case .countUp:
            return LocalizableString.enterStopwatchNameToCreate.localized
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
