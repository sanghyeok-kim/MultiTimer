//
//  TimerMO+CoreDataClass.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/23.
//
//

import Foundation
import CoreData

@objc(TimerMO)
public class TimerMO: NSManagedObject {

}

extension TimerMO: ModelConvertible {
    func toModel() -> Timer? {
        guard let identifier = identifier,
              let name = name,
              let time = time?.toModel() else { return nil }
        return Timer(
            identifier: identifier,
            name: name,
            tag: tag?.toModel(),
            time: time,
            state: state,
            expireDate: expireDate,
            startDate: startDate,
            type: type,
            ringtone: ringtone,
            index: Int(index)
        )
    }
}

extension TimerMO {
    func update(
        identifier: UUID? = nil,
        name: String? = nil,
        tag: Tag? = nil,
        time: Time? = nil,
        state: TimerState? = nil,
        expireDate: Date? = nil,
        startDate: Date? = nil,
        notificationIdentifier: String? = nil,
        type: TimerType? = nil,
        ringtone: Ringtone? = nil,
        index: Int? = nil,
        context: NSManagedObjectContext
    ) {
        self.identifier = identifier ?? self.identifier
        self.name = name ?? self.name
        self.tag = tag?.toManagedObejct(in: context) ?? self.tag
        self.time = time?.toManagedObejct(in: context) ?? self.time
        self.state = state ?? self.state
        self.expireDate = expireDate ?? self.expireDate
        self.startDate = startDate ?? self.startDate
        self.notificationIdentifier = notificationIdentifier ?? self.notificationIdentifier
        self.type = type ?? self.type
        self.ringtone = ringtone ?? self.ringtone
        self.index = Int16(index ?? Int(self.index))
    }
}

extension TimerMO {
    var totalSeconds: Int {
        return Int(time?.totalSeconds ?? 0)
    }
    
    var state: TimerState {
        get {
            return TimerState(rawValue: Int(self.stateValue)) ?? .ready
        }
        set {
            self.stateValue = Int16(newValue.rawValue)
        }
    }
    
    var type: TimerType {
        get {
            return TimerType(rawValue: Int(self.typeValue)) ?? .countDown
        }
        set {
            self.typeValue = Int16(newValue.rawValue)
        }
    }
    
    var ringtone: Ringtone? {
        get {
            guard let ringtoneValue = self.ringtoneValue else { return nil }
            return Ringtone(rawValue: ringtoneValue)
        }
        set {
            self.ringtoneValue = newValue?.rawValue
        }
    }
}

@frozen
enum TimerState: Int {
    case ready
    case running
    case paused
    case finished
}
