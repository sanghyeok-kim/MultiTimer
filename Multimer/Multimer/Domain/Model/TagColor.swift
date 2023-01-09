//
//  TagColor.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/17.
//

import Foundation
import CoreData

enum TagColor: Int, CaseIterable, Codable {
    case label
    case red
    case orange
    case pink
    case cyan
    case navy
    case purple
}

extension TagColor: ManagedObjectConvertible {
    func toManagedObejct(in context: NSManagedObjectContext) -> TagColorMO {
        let tagColorMO = TagColorMO(context: context)
        tagColorMO.update(rawValue: rawValue)
        return tagColorMO
    }
}
