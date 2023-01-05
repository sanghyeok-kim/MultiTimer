//
//  MainUseCase.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/29.
//

import RxSwift

final class DefaultMainUseCase: MainUseCase {
    
    let fetchedUserTimers = PublishSubject<[Timer]>()
    let fetchErrorMessage = PublishSubject<String>()
//    let cannotCreateMoreMessage = PublishSubject<String>()
//    let deleteErrorMessage = PublishSubject<String>()
    
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
        // TODO: 추가할 수 있는 최대 타이머 개수 확인 로직 추가 - 더 이상 추가할 수 없다는 message accept 보내고 return
//        if !timerPersistentRepository.canCreate() {
//            cannotCreateMoreMessage.onNext(<#T##element: String##String#>)
//            return
//        }
        timerPersistentRepository.create(timer: timer)
    }
}
