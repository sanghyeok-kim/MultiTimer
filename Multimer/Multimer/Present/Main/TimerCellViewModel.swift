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
    }
    
    let input = Input()
    let output = Output()
    let timerUseCase: TimerUseCase
    
    var isActive = false
    let identifier = UUID()
    private let disposeBag = DisposeBag()
    
    init(timerUseCase: TimerUseCase) {
        self.timerUseCase = timerUseCase
        
        // MARK: - Handle Event from Input
        
        handleToggleButtonDidTapFromInput()
        handleResetButtonDidTapFromInput()
        handleCellDidTapFromInput(with: timerUseCase)
        
        // MARK: - Handle Event from UseCase
        
        handleTimerEventFromUseCase()
    }
}

// MARK: - Event Handling Function

private extension TimerCellViewModel {
    func handleToggleButtonDidTapFromInput() {
        input.toggleButtonDidTap
            .withLatestFrom(output.toggleButtonIsSelected)
            .bind(onNext: toggleTimer)
            .disposed(by: disposeBag)
    }
    
    func handleResetButtonDidTapFromInput() {
        input.resetButtonDidTap
            .bind(onNext: resetTimer)
            .disposed(by: disposeBag)
    }
    
    func handleCellDidTapFromInput(with timerUseCase: TimerUseCase) {
        let settingViewModel = input.cellDidTap
            .map { TimerSettingViewModel(timer: timerUseCase.initialTimer) }
            .share()
        
        settingViewModel
            .bind(to: output.timerSettingViewModel)
            .disposed(by: disposeBag)
        
        settingViewModel
            .flatMapLatest { $0.output.newTimer }
            .bind(onNext: changeTimer)
            .disposed(by: disposeBag)
    }
    
    func handleTimerEventFromUseCase() {
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
            .bind(onNext: stopTimer)
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
        isActive = !isRunning
        output.toggleButtonIsSelected.accept(!isRunning)
    }
    
    func stopTimer() {
        timerUseCase.stopTimer()
        output.toggleButtonIsSelected.accept(false)
        output.toggleButtonIsHidden.accept(true)
        output.restartButtonIsHidden.accept(false)
    }
    
    func resetTimer() {
        timerUseCase.resetTimer()
        isActive = false
        output.toggleButtonIsHidden.accept(false)
        output.restartButtonIsHidden.accept(true)
    }
    
    func readyTimer() {
        output.toggleButtonIsSelected.accept(false)
        output.toggleButtonIsHidden.accept(false)
        output.restartButtonIsHidden.accept(true)
    }
    
    func changeTimer(to newTimer: Timer) {
        timerUseCase.changeTimer(to: newTimer)
        readyTimer()
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
