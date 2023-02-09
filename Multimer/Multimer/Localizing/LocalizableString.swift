//
//  LocalizableString.swift
//  Pods
//
//  Created by 김상혁 on 2022/12/30.
//

import Foundation

enum LocalizableString {
    case appTitle
    case timer
    case stopwatch
    case countDownTimer
    case countUpStopwatch
    case hour
    case minute
    case second
    case all
    case activated
    case enterTimerNameToCreate
    case enterStopwatchNameToCreate
    case createTimer
    case edit
    case done
    case deleteTimer
    case cancel
    case delete
    case deleteConfirmMessage(count: Int)
    case noTimerCreatedMessage
    case addTimerMessage
    case noTimerActivatedMessage
    case onlyActiveTimersAppearMessage
    case settingTimer(timerType: TimerType)
    case timerExpired(timerName: String)
    case defaultName
    case swipeRightToStop
    
    var localized: String {
        switch self {
        case .appTitle:
            return String(format: NSLocalizedString("appTitle", comment: ""))
        case .timer:
            return String(format: NSLocalizedString("timer", comment: ""))
        case .stopwatch:
            return String(format: NSLocalizedString("stopwatch", comment: ""))
        case .countDownTimer:
            return String(format: NSLocalizedString("countDownTimer", comment: ""))
        case .countUpStopwatch:
            return String(format: NSLocalizedString("countUpStopwatch", comment: ""))
        case .hour:
            return String(format: NSLocalizedString("hour", comment: ""))
        case .minute:
            return String(format: NSLocalizedString("minute", comment: ""))
        case .second:
            return String(format: NSLocalizedString("second", comment: ""))
        case .all:
            return String(format: NSLocalizedString("all", comment: ""))
        case .activated:
            return String(format: NSLocalizedString("activated", comment: ""))
        case .enterTimerNameToCreate:
            return String(format: NSLocalizedString("enterTimerNameToCreate", comment: ""))
        case . enterStopwatchNameToCreate:
            return String(format: NSLocalizedString("enterStopwatchNameToCreate", comment: ""))
        case .createTimer:
            return String(format: NSLocalizedString("createTimer", comment: ""))
        case .edit:
            return String(format: NSLocalizedString("edit", comment: ""))
        case .done:
            return String(format: NSLocalizedString("done", comment: ""))
        case .deleteTimer:
            return String(format: NSLocalizedString("deleteTimer", comment: ""))
        case .cancel:
            return String(format: NSLocalizedString("cancel", comment: ""))
        case .delete:
            return String(format: NSLocalizedString("delete", comment: ""))
        case .deleteConfirmMessage(let count):
            return String(format: NSLocalizedString("deleteConfirmMessage", comment: ""), arguments: [count])
        case .noTimerCreatedMessage:
            return String(format: NSLocalizedString("noTimerCreatedMessage", comment: ""))
        case .addTimerMessage:
            return String(format: NSLocalizedString("addTimerMessage", comment: ""))
        case .noTimerActivatedMessage:
            return String(format: NSLocalizedString("noTimerActivatedMessage", comment: ""))
        case .onlyActiveTimersAppearMessage:
            return String(format: NSLocalizedString("onlyActiveTimersAppearMessage", comment: ""))
        case .settingTimer(let timerType):
            return String(format: NSLocalizedString("settingTimer", comment: ""), arguments: [timerType.title])
        case .timerExpired(let timerName):
            return String(format: NSLocalizedString("timerExpired", comment: ""), arguments: [timerName])
        case .defaultName:
            return String(format: NSLocalizedString("defaultName", comment: ""))
        case .swipeRightToStop:
            return String(format: NSLocalizedString("swipeRightToStop", comment: ""))
        }
    }
}
