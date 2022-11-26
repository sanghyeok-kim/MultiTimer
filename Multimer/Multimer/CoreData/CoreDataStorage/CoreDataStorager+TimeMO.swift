//
//  CoreDataStorage+TimeMO.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/23.
//

import Foundation
import CoreData

extension CoreDataStorage {
    func update(timeMO: TimeMO,
                totalSeconds: Int,
                completion: (() -> Void)? = nil) {
        mainContext.perform { [weak self] in
            guard let self = self else { return }
            defer { completion?() }
            timeMO.update(totalSeconds: totalSeconds)
            self.saveMainContext()
        }
    }
}
