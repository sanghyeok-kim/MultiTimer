//
//  DefaultHomeUseCase.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/29.
//

import RxSwift

final class DefaultHomeUseCase: HomeUseCase {
    
    let fetchedUserTimers = PublishSubject<[Timer]>()
    let fetchErrorMessage = PublishSubject<String>()
    
    private let timerPersistentRepository: TimerPersistentRepository
    private let disposeBag = DisposeBag()
    
    init(timerPersistentRepository: TimerPersistentRepository) {
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
    
    func deleteTimer(target identifier: UUID) {
        timerPersistentRepository
            .deleteTimer(target: identifier)
            .subscribe(onCompleted: { [weak self] in
                guard let self = self else { return }
                self.timerPersistentRepository.reindexTimers()
            })
            .disposed(by: disposeBag)
    }
    
    func moveTimer(target identifier: UUID, to destination: Int) {
        timerPersistentRepository.updateTimerIndex(target: identifier, to: destination)
    }
    
    func appendTimer(_ timer: Timer) {
        timerPersistentRepository.create(timer: timer)
    }
}
