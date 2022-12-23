//
//  CoreDataStorage+TimerMO.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/23.
//

import Foundation
import CoreData

extension CoreDataStorage {
    func update(
        timerMO: TimerMO,
        identifier: UUID? = nil,
        name: String? = nil,
        tag: Tag? = nil,
        time: Time? = nil,
        state: TimerState? = nil,
        expireDate: Date? = nil,
        startDate: Date? = nil,
        notificationIdentifier: String? = nil,
        type: TimerType? = nil,
        index: Int? = nil
    ) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
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
                context: self.backgroundContext
            )
            self.saveContext()
        }
    }
}
