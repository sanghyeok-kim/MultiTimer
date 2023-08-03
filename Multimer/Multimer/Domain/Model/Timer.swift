//
//  Timer.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import Foundation
import CoreData

struct Timer {
    let identifier: UUID
    var name: String
    var tag: Tag?
    var time: Time
    var state: TimerState
    var expireDate: Date?
    var startDate: Date?
    var notificationIdentifier: String?
    var type: TimerType
    var ringtone: Ringtone?
    var index: Int
    
    // TODO: Sound, RepeatCount
    
    var totalSeconds: Int {
        return time.totalSeconds
    }
    
    var remainingSeconds: Double {
        return time.remainingSeconds
    }
    
    init(identifier: UUID = UUID(),
         name: String = "",
         tag: Tag? = nil,
         time: Time = TimeFactory.createDefaultTime(),
         state: TimerState = .ready,
         expireDate: Date? = nil,
         startDate: Date? = nil,
         type: TimerType = .countDown,
         ringtone: Ringtone? = .default1,
         index: Int = .zero) {
        self.identifier = identifier
        self.name = name
        self.tag = tag
        self.time = time
        self.state = state
        self.expireDate = expireDate
        self.startDate = startDate
        self.notificationIdentifier = identifier.uuidString
        self.type = type
        self.ringtone = ringtone
        self.index = index
    }
    
    init(timer: Timer, time: Time) {
        self.identifier = timer.identifier
        self.name = timer.name
        self.tag = timer.tag
        self.time = time
        self.state = timer.state
        self.expireDate = timer.expireDate
        self.startDate = timer.startDate
        self.notificationIdentifier = timer.identifier.uuidString
        self.type = timer.type
        self.ringtone = timer.ringtone
        self.index = timer.index
    }
    
    //TODO: 팩토리로 분리
    static func updateIndex(of timer: Timer, index: Int) -> Timer {
        var newTimer = timer
        newTimer.index = index
        return newTimer
    }
}

extension Timer: Equatable {
    static func == (lhs: Timer, rhs: Timer) -> Bool {
        return (lhs.name == rhs.name)
        && (lhs.tag == rhs.tag)
        && (lhs.time == rhs.time)
        && (lhs.ringtone == rhs.ringtone)
    }
}

extension Timer: ManagedObjectConvertible {
    func toManagedObejct(in context: NSManagedObjectContext) -> TimerMO {
        let timerMO = TimerMO(context: context)
        timerMO.update(
            identifier: identifier,
            name: name,
            tag: tag,
            time: time,
            state: state,
            expireDate: expireDate,
            startDate: startDate,
            notificationIdentifier: notificationIdentifier,
            type: type,
            ringtone: ringtone,
            index: index,
            context: context
        )
        return timerMO
    }
}
