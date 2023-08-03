//
//  CoreDataTimerRepository.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/07.
//

import RxSwift
import CoreData

final class CoreDataTimerRepository: TimerPersistentRepository {
    
    private let coreDataStorage: CoreDataStorage
    private let disposeBag = DisposeBag()
    
    private var timerFetchRequestSortedByIndex: NSFetchRequest<TimerMO> {
        let request: NSFetchRequest<TimerMO> = TimerMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    func create(timer: Timer) {
        coreDataStorage
            .fetch(request: timerFetchRequestSortedByIndex)
            .subscribe(onSuccess: { [weak self] result in
                guard let self = self else { return }
                let lastIndex = Int(result.last?.index ?? 0)
                self.coreDataStorage.create(from: Timer.updateIndex(of: timer, index: lastIndex + 1))
            })
            .disposed(by: disposeBag)
    }
    
    func fetchTimers() -> Observable<[Timer]> {
        return coreDataStorage
            .fetch(request: timerFetchRequestSortedByIndex)
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
        state: TimerState? = nil,
        expireDate: Date? = nil,
        startDate: Date? = nil,
        type: TimerType? = nil,
        ringtone: Ringtone? = nil
    ) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else { return Disposables.create { } }
            self.findTimer(target: identifier)
                .bind { updateTarget in
                    self.coreDataStorage.update(
                        timerMO: updateTarget,
                        name: name,
                        tag: tag,
                        time: time,
                        state: state,
                        expireDate: expireDate,
                        startDate: startDate,
                        type: type,
                        ringtone: ringtone
                    )
                    completable(.completed)
                }
                .disposed(by: self.disposeBag)
            return Disposables.create { }
        }
    }
    
    func saveTimeOfTimer(
        target identifier: UUID,
        time: Time? = nil,
        state: TimerState? = nil,
        expireDate: Date? = nil,
        startDate: Date? = nil
    ) {
        findTimer(target: identifier)
            .withUnretained(self)
            .bind { `self`, updateTarget in
                self.coreDataStorage.update(timerMO: updateTarget, time: time, state: state, expireDate: expireDate)
            }
            .disposed(by: self.disposeBag)
    }
    
    func deleteTimer(target identifier: UUID) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else { return Disposables.create { } }
            self.findTimer(target: identifier)
                .bind { deleteTarget in
                    self.coreDataStorage.delete(object: deleteTarget)
                    completable(.completed)
                }
                .disposed(by: self.disposeBag)
            return Disposables.create { }
        }
    }
    
    func reindexTimers() {
        coreDataStorage
            .fetch(request: timerFetchRequestSortedByIndex)
            .subscribe(onSuccess: { [weak self] timerMOs in
                guard let self = self else { return }
                timerMOs.enumerated().forEach { index, timerMO in
                    timerMO.update(index: index, context: self.coreDataStorage.backgroundContext)
                    self.coreDataStorage.saveContext()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func updateTimerIndex(target identifier: UUID, to changedIndex: Int) {
        findTimer(target: identifier)
            .withUnretained(self)
            .bind { `self`, timerMO in
                timerMO.update(index: changedIndex, context: self.coreDataStorage.backgroundContext)
                self.coreDataStorage.saveContext()
            }
            .disposed(by: disposeBag)
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
