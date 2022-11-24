//
//  CoreDataManager.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/23.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() { }
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TimerModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveMainContext() {
        mainContext.perform { [weak self] in //Thread-Safe한 쓰기 작업을 위해 Context를 실행하는 Thread로 전환해서 작업
            guard let self = self else { return }
            if self.mainContext.hasChanges {
                do { try self.mainContext.save()
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
}

extension CoreDataManager {
    func fetch<MO: NSManagedObject>(request: NSFetchRequest<MO>) -> [MO] {
        var result: [MO] = []
        
        mainContext.performAndWait {
            do {
                result = try mainContext.fetch(request)
            } catch {
                debugPrint(error.localizedDescription) //FIXME: Error Handling
            }
        }
        return result
    }
    
    func create<Model: ManagedObjectConvertible>(from model: Model, completion: (() -> Void)? = nil) {
        mainContext.perform { [weak self] in
            guard let self = self else { return }
            defer { completion?() }
            model.toManagedObejct(in: self.mainContext)
            self.saveMainContext()
        }
    }
    
    func delete<MO: NSManagedObject>(object: MO, completion: (() -> Void)? = nil) {
        mainContext.perform { [weak self] in
            guard let self = self else { return }
            defer { completion?() }
            self.mainContext.delete(object)
            self.saveMainContext()
        }
    }
}
