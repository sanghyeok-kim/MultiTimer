//
//  CoreDataStorage.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/23.
//

import RxSwift
import CoreData

class CoreDataStorage {
    static let shared = CoreDataStorage()
    
    private init() { }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TimerModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })
        return container
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let newbackgroundContext = persistentContainer.newBackgroundContext()
        newbackgroundContext.automaticallyMergesChangesFromParent = true
        return newbackgroundContext
    }()
    
    func saveContext() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
}

extension CoreDataStorage {
    func fetch<MO: NSManagedObject>(request: NSFetchRequest<MO>, predicate: NSPredicate? = nil) -> Single<[MO]> {
        return Single<[MO]>.create { [weak self] observer in
            self?.backgroundContext.perform {
                do {
                    request.predicate = predicate
                    guard let result = try self?.backgroundContext.fetch(request) else { return }
                    observer(.success(result))
                } catch {
                    observer(.failure(CoreDataError.cannotFetch))
                }
            }
            return Disposables.create { }
        }
    }
    
    func fetchCount<MO: NSManagedObject>(request: NSFetchRequest<MO>) -> Int {
        var count = 0
        backgroundContext.performAndWait {
            do {
                count = try backgroundContext.count(for: request)
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        return count
    }
    
    func create<Model: ManagedObjectConvertible>(from model: Model) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            model.toManagedObejct(in: self.backgroundContext)
            self.saveContext()
        }
    }
    
    func delete<MO: NSManagedObject>(object: MO) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            self.backgroundContext.delete(object)
            self.saveContext()
        }
    }
}
