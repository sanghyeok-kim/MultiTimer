//
//  CoreDataStorage+TimeMO.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/23.
//

import Foundation
import CoreData

extension CoreDataStorage {
//    func update(timeMO: TimeMO, totalSeconds: Int? = nil, remainingSeconds: Int? = nil) {
    func update(timeMO: TimeMO, totalSeconds: Int? = nil, remainingSeconds: Double? = nil) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            timeMO.update(totalSeconds: totalSeconds, remainingSeconds: remainingSeconds)
            self.saveContext()
        }
    }
}
