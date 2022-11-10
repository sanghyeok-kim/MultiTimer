//
//  TimeType.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import Foundation

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
            return "시간"
        case .minute:
            return "분"
        case .second:
            return "초"
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
