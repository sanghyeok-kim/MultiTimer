//
//  TagMO+CoreDataClass.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/23.
//
//

import Foundation
import CoreData

@objc(TagMO)
public class TagMO: NSManagedObject {

}

extension TagMO: ModelConvertible {
    func toModel() -> Tag {
        let color = color?.toModel() ?? .label
        return Tag(isSelected: isSelected, color: color)
    }
}

extension TagMO {
    func update(isSelected: Bool? = nil, color: TagColor? = nil, context: NSManagedObjectContext) {
        self.isSelected = isSelected ?? self.isSelected
        self.color = color?.toManagedObejct(in: context) ?? self.color
    }
}
