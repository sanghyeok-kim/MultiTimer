//
//  TagColorMO+CoreDataClass.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/23.
//
//

import Foundation
import CoreData

@objc(TagColorMO)
public class TagColorMO: NSManagedObject {

}

extension TagColorMO: ModelConvertible {
    func toModel() -> TagColor {
        return TagColor(rawValue: Int(rawValue)) ?? .label
    }
}

extension TagColorMO {
    func update(rawValue: Int) {
        self.rawValue = Int16(rawValue)
    }
}
