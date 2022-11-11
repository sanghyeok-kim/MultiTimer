//
//  TimerCellViewModel.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/04.
//

import RxSwift
import RxRelay

final class TimerCellViewModel: ViewModelType {
    
    struct Input {
        let cellDidTap: Observable<Void>
        let toggleButtonDidTap: Observable<Void>
        let restartButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let timer: BehaviorRelay<Timer>
        let time: BehaviorRelay<Time> // FIXME: Relay -> onComplete 처리 가능하도록 변경
        let toggleButtonIsSelected = BehaviorRelay<Bool>(value: false)
        let toggleButtonIsHidden = BehaviorRelay<Bool>(value: false)
        let restartButtonIsHidden = BehaviorRelay<Bool>(value: true)
        let timerSettingViewModel = PublishRelay<TimerSettingViewModel>()
    }
    
    // TODO: UseCase로 분리
    private var timerDisposable: Disposable? = nil
    private var currentTotalSeconds: Int
    
    let output: Output
    
    init(timer: Timer) {
        self.currentTotalSeconds = timer.time.totalSeconds
        output = Output(
            timer: BehaviorRelay<Timer>(value: timer),
            time: BehaviorRelay<Time>(value: timer.time)
        )
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let toggleButtonDidTap = input.toggleButtonDidTap.share()
        let restartButtonDidTap = input.restartButtonDidTap.share()
        let cellDidTap = input.cellDidTap.share()
        
        toggleButtonDidTap
            .scan(output.toggleButtonIsSelected.value) { lastState, newState in
                !lastState
            }
            .bind(to: output.toggleButtonIsSelected)
            .disposed(by: disposeBag)
        
        toggleButtonDidTap
            .withLatestFrom(output.toggleButtonIsSelected)
            .filter { $0 }
            .withUnretained(self)
            .bind { `self`, _ in
                self.timerDisposable = Observable<Int>.interval(
                    .seconds(1),
                    scheduler: ConcurrentDispatchQueueScheduler(queue: .global(qos: .background))
                )
                .scan(self.currentTotalSeconds) { lastState, newState in
                    lastState - 1
                }
                .take(until: { $0 < 0 })
                .map { Time(totalSeconds: $0) }
                .do { self.currentTotalSeconds = $0.totalSeconds }
                .bind(to: self.output.time)
            }
            .disposed(by: disposeBag)
        
        toggleButtonDidTap
            .withLatestFrom(output.toggleButtonIsSelected)
            .filter { !$0 }
            .withUnretained(self)
            .bind { `self`, _ in
                self.timerDisposable?.dispose()
            }
            .disposed(by: disposeBag)
        
//        output.time
//            .subscribe(onCompleted: { [weak self] in // unretained?
//                guard let self = self else { return }
//                self.output.toggleButtonIsSelected.accept(false)
//                self.output.toggleButtonIsHidden.accept(true)
//                self.output.restartButtonIsHidden.accept(false)
//            })
//            .disposed(by: disposeBag)
        
        restartButtonDidTap
            .withUnretained(self)
            .bind { `self`, _ in
                self.output.toggleButtonIsHidden.accept(false)
                self.output.restartButtonIsHidden.accept(true)
//            self.output.time.onNext(self.initialTime)
//            print(self.initialTime)
            }
            .disposed(by: disposeBag)
        
        let settingViewModel = cellDidTap
            .withLatestFrom(output.timer)
            .map { TimerSettingViewModel(timer: $0) }
            .share()
        
        settingViewModel
            .bind(to: output.timerSettingViewModel)
            .disposed(by: disposeBag)
        
        let changedTimer = settingViewModel
            .flatMapLatest { $0.output.newTimer }
            .share()
        
        changedTimer
            .bind(to: output.timer)
            .disposed(by: disposeBag)
        
        changedTimer
            .map { $0.time }
            .bind(to: output.time)
            .disposed(by: disposeBag)
        
        return output
    }
}

