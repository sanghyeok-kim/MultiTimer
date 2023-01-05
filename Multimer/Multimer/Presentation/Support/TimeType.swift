//
//  TimeType.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import Foundation

@frozen
enum TimeType: CaseIterable {
    case hour
    case minute
    case second
    
    static subscript(index: Int) -> Self {
        return Self.allCases[index]
    }
    
    static var count: Int {
        return Self.allCases.count
    }
    
    var title: String {
        switch self {
        case .hour:
            return LocalizableString.hour.localized
        case .minute:
            return LocalizableString.minute.localized
        case .second:
            return LocalizableString.second.localized
        }
    }
    
    var range: [Int] {
        switch self {
        case .hour:
            return (0...999).map { $0 }
        case .minute:
            return (0...59).map { $0 }
        case .second:
            return (0...59).map { $0 }
        }
    }
    
    var rangeCount: Int {
        return range.count
    }
}
