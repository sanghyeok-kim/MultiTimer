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
        let toggleButtonDidTap = PublishRelay<Void>()
        let resetButtonDidTap = PublishRelay<Void>()
        let cellDidTap = PublishRelay<Void>()
    }
    
    struct Output {
        let timer = BehaviorRelay<Timer>(value: Timer())
        let toggleButtonIsSelected = BehaviorRelay<Bool>(value: false)
        let toggleButtonIsHidden = BehaviorRelay<Bool>(value: false)
        let restartButtonIsHidden = BehaviorRelay<Bool>(value: true)
        let timerSettingViewModel = PublishRelay<TimerSettingViewModel>()
        let isActive = BehaviorRelay<Bool>(value: false)
    }
    
    let input = Input()
    let output = Output()
    let timerUseCase: TimerUseCase
    
    let identifier = UUID()
    private let disposeBag = DisposeBag()
    
    init(timerUseCase: TimerUseCase) {
        self.timerUseCase = timerUseCase
        
        // MARK: - Handle Event from Input
        
        handleToggleButtonDidTap()
        handleResetButtonDidTap()
        handleCellDidTap(with: timerUseCase)
        
        // MARK: - Handle Event from UseCase
        
        handleTimerEvent()
    }
}

// MARK: - Event Handling Function

private extension TimerCellViewModel {
    func handleToggleButtonDidTap() {
        input.toggleButtonDidTap
            .withLatestFrom(output.toggleButtonIsSelected)
            .withUnretained(self)
            .bind { `self`, isRunning in
                self.toggleTimer(by: isRunning)
            }
            .disposed(by: disposeBag)
    }
    
    func handleResetButtonDidTap() {
        input.resetButtonDidTap
            .withUnretained(self)
            .bind { `self`, _ in
                self.resetTimer()
            }
            .disposed(by: disposeBag)
    }
    
    func handleCellDidTap(with timerUseCase: TimerUseCase) {
        let settingViewModel = input.cellDidTap
            .map { TimerSettingViewModel(timer: timerUseCase.initialTimer) }
            .share()
        
        settingViewModel
            .bind(to: output.timerSettingViewModel)
            .disposed(by: disposeBag)
        
        settingViewModel
            .flatMapLatest { $0.output.newTimer }
            .withUnretained(self)
            .bind { `self`, newTimer in
                self.changeTimer(to: newTimer)
            }
            .disposed(by: disposeBag)
    }
    
    func handleTimerEvent() {
        let timerEvent = timerUseCase.timer
            .observe(on: MainScheduler.instance)
            .share()
        
        timerEvent
            .bind(to: output.timer)
            .disposed(by: disposeBag)
        
        timerEvent
            .map { $0.time.totalSeconds }
            .filter { $0 == .zero }
            .map { _ in }
            .withUnretained(self)
            .bind { `self`, _ in
                self.stopTimer()
            }
            .disposed(by: disposeBag)
        
            .disposed(by: disposeBag)
    }
}

// MARK: - Supporting Function

private extension TimerCellViewModel {
    func toggleTimer(by isRunning: Bool) {
        switch isRunning {
        case true: timerUseCase.pauseTimer()
        case false: timerUseCase.startTimer()
        }
        output.isActive.accept(true)
        output.toggleButtonIsSelected.accept(!isRunning)
    }
    
    func stopTimer() {
        timerUseCase.stopTimer()
        output.toggleButtonIsSelected.accept(false)
        output.toggleButtonIsHidden.accept(true)
        output.restartButtonIsHidden.accept(false)
    }
    
    func resetTimer() {
        timerUseCase.stopTimer()
        timerUseCase.resetTimer()
        timerUseCase.removeNotification()
        output.isActive.accept(false)
        output.toggleButtonIsSelected.accept(false)
        output.toggleButtonIsHidden.accept(false)
        output.restartButtonIsHidden.accept(true)
    }
    
    func changeTimer(to newTimer: Timer) {
        timerUseCase.stopTimer()
        timerUseCase.changeTimer(to: newTimer)
        timerUseCase.removeNotification()
        resetTimer()
    }
}

// MARK: - Adopt Hashable

extension TimerCellViewModel: Hashable {
    static func == (lhs: TimerCellViewModel, rhs: TimerCellViewModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
