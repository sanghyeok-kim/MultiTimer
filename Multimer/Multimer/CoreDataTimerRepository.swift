//
//  CoreDataTimerRepository.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/07.
//

import RxSwift
import CoreData

final class CoreDataTimerRepository {
    
    private var maximumStorageCount: Int
    private let coreDataStorage: CoreDataStorage
    private let disposeBag = DisposeBag()
    
    init(maximumStorageCount: Int, coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.maximumStorageCount = maximumStorageCount
        self.coreDataStorage = coreDataStorage
    }
    
    func create(timer: Timer) {
        coreDataStorage.create(from: timer)
    }
    
    func fetchTimers() -> Observable<[Timer]> {
        let request: NSFetchRequest<TimerMO> = TimerMO.fetchRequest()
        return coreDataStorage.fetch(request: request)
            .asObservable()
            .map { result -> [Timer] in
                result.compactMap { $0.toModel() }
            }
    }
    
    func updateTimer(
        target identifier: UUID,
        name: String? = nil,
        tag: Tag? = nil,
        time: Time? = nil,
        startDate: Date? = nil,
        state: TimerState? = nil
    ) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else { return Disposables.create { } }
            self.findTimer(target: identifier)
                .bind { updateTarget in
                    self.coreDataStorage.update(timerMO: updateTarget, name: name, tag: tag, time: time, startDate: startDate, state: state)
                    completable(.completed)
                }
                .disposed(by: self.disposeBag)
            return Disposables.create { }
        }
    }
    
    func deleteTimer(target identifier: UUID) -> Observable<Timer> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create { } }
            
            self.findTimer(target: identifier)
                .bind { deleteTarget in
                    self.coreDataStorage.delete(object: deleteTarget)
                    guard let deletedTimer = deleteTarget.toModel() else { return }
                    observer.onNext(deletedTimer)
                }
                .disposed(by: self.disposeBag)
            
            return Disposables.create { }
        }
    }
    
    func findTimer(target identifier: UUID) -> Observable<TimerMO> {
        let request: NSFetchRequest<TimerMO> = TimerMO.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(TimerMO.identifier), identifier as CVarArg)
        return coreDataStorage
            .fetch(request: request, predicate: predicate)
            .asObservable()
            .compactMap { $0.first }
    }
}
