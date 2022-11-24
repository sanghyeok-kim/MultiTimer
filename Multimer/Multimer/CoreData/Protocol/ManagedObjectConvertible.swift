//
//  ManagedObjectConvertible.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/23.
//

import Foundation
import CoreData

protocol ManagedObjectConvertible {
    associatedtype ManagedObejct: NSManagedObject
    
    @discardableResult
    func toManagedObejct(in context: NSManagedObjectContext) -> ManagedObejct
}
