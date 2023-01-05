//
//  Identifiable.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/04.
//

import Foundation

protocol CellIdentifiable { }

extension CellIdentifiable {
    static var identifier: String {
        String(describing: self)
    }
}
