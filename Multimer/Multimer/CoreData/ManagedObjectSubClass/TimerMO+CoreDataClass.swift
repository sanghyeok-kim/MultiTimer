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
        guard let name = name,
              let time = time?.toModel() else { return nil }
        return Timer(name: name, tag: tag?.toModel(), time: time)
    }
}

extension TimerMO {
    func update(name: String? = nil, tag: Tag? = nil, time: Time? = nil, context: NSManagedObjectContext) {
        self.name = name ?? self.name
        self.tag = tag?.toManagedObejct(in: context) ?? self.tag
        self.time = time?.toManagedObejct(in: context) ?? self.time
    }
}
