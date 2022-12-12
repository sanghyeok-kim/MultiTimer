//
//  TimeMO+CoreDataClass.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/23.
//
//

import Foundation
import CoreData

@objc(TimeMO)
public class TimeMO: NSManagedObject {

}

extension TimeMO: ModelConvertible {
    func toModel() -> Time {
        return Time(totalSeconds: Int(totalSeconds), remainingSeconds: remainingSeconds)
    }
}

extension TimeMO {
    func update(totalSeconds: Int? = nil, remainingSeconds: Double? = nil) {
        self.totalSeconds = Int32(totalSeconds ?? Int(self.totalSeconds))
        self.remainingSeconds = remainingSeconds ?? self.remainingSeconds
    }
}
