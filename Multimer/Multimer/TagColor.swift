//
//  TagColor.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/17.
//

import UIKit
import CoreData

enum TagColor: Int, CaseIterable, Codable {
    case label
    case red
    case orange
    case pink
    case cyan
    case navy
    case purple
    
    var uiColor: UIColor {
        switch self {
        case .label:
            return CustomColor.Tag.label
        case .red:
            return CustomColor.Tag.red
        case .orange:
            return CustomColor.Tag.orange
        case .pink:
            return CustomColor.Tag.pink
        case .cyan:
            return CustomColor.Tag.cyan
        case .navy:
            return CustomColor.Tag.navy
        case .purple:
            return CustomColor.Tag.purple
        }
    }
}

extension TagColor: ManagedObjectConvertible {
    func toManagedObejct(in context: NSManagedObjectContext) -> TagColorMO {
        let tagColorMO = TagColorMO(context: context)
        tagColorMO.update(rawValue: rawValue)
        return tagColorMO
    }
}
