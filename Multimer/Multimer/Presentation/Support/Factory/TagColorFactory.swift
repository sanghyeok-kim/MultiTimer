//
//  TagColorFactory.swift
//  Multimer
//
//  Created by 김상혁 on 2023/01/06.
//

import UIKit

struct TagColorFactory {
    static func generateUIColor(of tagColor: TagColor?) -> UIColor {
        guard let tagColor = tagColor else { return .label }
        
        switch tagColor {
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
