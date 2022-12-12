//
//  CoreDataStorage+TimerMO.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/23.
//

import Foundation
import CoreData

extension CoreDataStorage {
//    func update(
//        timerMO: TimerMO,
//        identifier: UUID? = nil,
//        name: String? = nil,
//        tag: Tag? = nil,
//        time: Time? = nil
//    ) {
//        backgroundContext.perform { [weak self] in
//            guard let self = self else { return }
//            timerMO.update(
//                name: name,
//                tag: tag,
//                time: time,
//                context: self.backgroundContext
//            )
//            self.saveContext()
//        }
//    }
    
    // TODO: 삭제
    func update(
        timerMO: TimerMO,
        identifier: UUID? = nil,
        name: String? = nil,
        tag: Tag? = nil,
        time: Time? = nil,
        expireDate: Date? = nil,
        state: TimerState? = nil,
        notificationIdentifier: String? = nil
    ) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            timerMO.update(
                name: name,
                tag: tag,
                time: time,
                expireDate: expireDate,
                state: state,
                notificationIdentifier: notificationIdentifier,
                context: self.backgroundContext
            )
            self.saveContext()
        }
    }
}
