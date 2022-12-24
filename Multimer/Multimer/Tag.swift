//
//  Tag.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import Foundation
import CoreData

struct Tag: Codable, Equatable {
    var isSelected: Bool = false
    var color: TagColor
}

extension Tag: ManagedObjectConvertible {
    func toManagedObejct(in context: NSManagedObjectContext) -> TagMO {
        let tagMO = TagMO(context: context)
        tagMO.update(isSelected: isSelected, color: color, context: context)
        return tagMO
    }
}
