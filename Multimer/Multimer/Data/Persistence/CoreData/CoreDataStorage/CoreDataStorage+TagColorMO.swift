//
//  CoreDataStorage+TagColorMO.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/23.
//

import Foundation
import CoreData

extension CoreDataStorage {
    func update(tagColorMO: TagColorMO, rawValue: Int) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            tagColorMO.update(rawValue: rawValue)
            self.saveContext()
        }
    }
}
