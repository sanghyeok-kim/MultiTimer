//
//  CoreDataStorage+TagMO.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/23.
//

import Foundation
import CoreData

extension CoreDataStorage {
    func update(tagMO: TagMO, isSelected: Bool? = nil, color: TagColor? = nil) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            tagMO.update(isSelected: isSelected, color: color, context: self.backgroundContext)
            self.saveContext()
        }
    }
}
