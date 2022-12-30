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
    case green
    case cyan
    case purple
    case navy
    
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
        case .green:
            return CustomColor.Tag.green
        case .cyan:
            return CustomColor.Tag.cyan
        case .purple:
            return CustomColor.Tag.purple
        case .navy:
            return CustomColor.Tag.navy
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
