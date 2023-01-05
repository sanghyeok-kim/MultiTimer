//
//  ModelConvertible.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/23.
//

import Foundation

protocol ModelConvertible {
    associatedtype Model
    
    func toModel() -> Model
}
