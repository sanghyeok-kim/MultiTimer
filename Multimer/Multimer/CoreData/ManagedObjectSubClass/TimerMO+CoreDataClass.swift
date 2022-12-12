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
        return Timer(identifier: identifier, name: name, tag: tag?.toModel(), time: time, state: state, expireDate: expireDate)
    }
}

extension TimerMO {
    func update(identifier: UUID? = nil,
                name: String? = nil,
                tag: Tag? = nil,
                time: Time? = nil,
                expireDate: Date? = nil,
                state: TimerState? = nil,
                notificationIdentifier: String? = nil,
                context: NSManagedObjectContext
    ) {
        self.identifier = identifier ?? self.identifier
        self.name = name ?? self.name
        self.tag = tag?.toManagedObejct(in: context) ?? self.tag
        self.time = time?.toManagedObejct(in: context) ?? self.time
        self.expireDate = expireDate ?? self.expireDate
        self.state = state ?? self.state
        self.notificationIdentifier = notificationIdentifier ?? self.notificationIdentifier
    }
}

extension TimerMO {
    var totalSeconds: Int {
        return Int(time?.totalSeconds ?? 0)
    }
    
    var state: TimerState {
        get {
            return TimerState(rawValue: self.stateValue) ?? .ready
        }
        set {
            self.stateValue = newValue.rawValue
        }
    }
}

@frozen
enum TimerState: Int16 {
    case ready
    case running
    case paused
    case finished
}
