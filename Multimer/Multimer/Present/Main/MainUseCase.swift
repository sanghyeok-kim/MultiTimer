//
//  MainUseCase.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/29.
//

import RxSwift

final class MainUseCase {
    
    let fetchedUserTimers = PublishSubject<[Timer]>()
    let fetchErrorMessage = PublishSubject<String>()
    let deleteErrorMessage = PublishSubject<String>()
    
    private let timerPersistentRepository: CoreDataTimerRepository
    private let disposeBag = DisposeBag()
    
    init(timerPersistentRepository: CoreDataTimerRepository) {
        self.timerPersistentRepository = timerPersistentRepository
    }
    
    func fetchUserTimers() {
        timerPersistentRepository
            .fetchTimers()
            .subscribe(onNext: { [weak self] timers in
                guard let self = self else { return }
                self.fetchedUserTimers.onNext(timers)
            }, onError: { [weak self] error in
                guard let self = self,
                      let error = error as? CoreDataError else { return }
                self.fetchErrorMessage.onNext(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteTimer(by identifier: UUID) {
        timerPersistentRepository
            .deleteTimer(target: identifier)
            .subscribe(onError: { [weak self] error in
                guard let self = self,
                      let error = error as? CoreDataError else { return }
                self.deleteErrorMessage.onNext(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func appendTimer(_ timer: Timer) {
        timerPersistentRepository.create(timer: timer)
    }
}
