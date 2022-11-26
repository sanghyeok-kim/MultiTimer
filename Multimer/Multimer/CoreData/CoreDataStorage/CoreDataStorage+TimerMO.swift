//
//  CoreDataStorage+TimerMO.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/23.
//

import Foundation
import CoreData

extension CoreDataStorage {
    func update(timerMO: TimerMO,
                identifier: UUID? = nil,
                name: String? = nil,
                tag: Tag? = nil,
                time: Time? = nil,
                completion: (() -> Void)? = nil) {
        mainContext.perform { [weak self] in
            guard let self = self else { return }
            defer { completion?() }
            timerMO.update(identifier: identifier, name: name, tag: tag, time: time, context: self.mainContext)
            self.saveMainContext()
        }
    }
    
    func deleteTimer(identifier: UUID, completion: (() -> Void)? = nil) {
        let request: NSFetchRequest<TimerMO> = TimerMO.fetchRequest()
        let data = fetch(request: request)
        let target = data.first { $0.identifier == identifier }
        guard let target = target else { return }
        
        mainContext.perform { [weak self] in
            guard let self = self else { return }
            defer { completion?() }
            self.mainContext.delete(target)
            self.saveMainContext()
        }
    }
}
