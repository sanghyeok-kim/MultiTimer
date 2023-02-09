//
//  CoreDataError.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/29.
//

import Foundation

enum CoreDataError: Error {
    case cannotFetch
    case cannotFindTarget
    case cannotCreateMore
    
    var localizedDescription: String {
        switch self {
        case .cannotFetch:
            return "저장된 타이머를 불러오는데 실패했습니다."
        case .cannotFindTarget:
            return "대상을 찾을 수 없습니다."
        case .cannotCreateMore:
            return "더 이상 생성할 수 없습니다."
        }
    }
}
