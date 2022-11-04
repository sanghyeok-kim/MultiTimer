//
//  Identifiable.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/04.
//

import Foundation

protocol Identifiable { }

extension Identifiable {
    static var identifier: String {
        String(describing: self)
    }
}
