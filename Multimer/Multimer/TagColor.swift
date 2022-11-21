//
//  TagColor.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/17.
//

import UIKit

enum TagColor: Int, CaseIterable, Codable {
    case red
    case blue
    case green
    case purple
    case yellow
    case brown
    case magenta
    case pink
    case orange
    case indigo
    
    var rgb: UIColor {
        switch self {
        case .red: return UIColor.red
        case .blue: return UIColor.blue
        case .green: return UIColor.green
        case .purple: return UIColor.purple
        case .yellow: return UIColor.yellow
        case .brown: return UIColor.brown
        case .magenta: return UIColor.magenta
        case .pink: return UIColor.systemPink
        case .orange: return UIColor.orange
        case .indigo: return UIColor.systemIndigo
        }
    }
}
