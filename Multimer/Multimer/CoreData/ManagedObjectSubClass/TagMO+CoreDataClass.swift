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
    func toModel() -> Tag? {
        guard let color = color?.toModel() else { return nil }
        return Tag(isSelected: isSelected, color: color)
    }
}

extension TagMO {
    func update(isSelected: Bool? = nil, color: TagColor? = nil, context: NSManagedObjectContext) {
        self.isSelected = isSelected ?? self.isSelected
        self.color = color?.toManagedObejct(in: context) ?? self.color
    }
}
