//
//  CoreDataManager+UpdateTimerMO.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/23.
//

import Foundation
import CoreData

extension CoreDataManager {
    func update(timerMO: TimerMO,
                name: String? = nil,
                tag: Tag? = nil,
                time: Time? = nil,
                completion: (() -> Void)? = nil) {
        mainContext.perform { [weak self] in
            guard let self = self else { return }
            defer { completion?() }
            timerMO.update(name: name, tag: tag, time: time, context: self.mainContext)
            self.saveMainContext()
        }
    }
}
