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
        let progess = BehaviorRelay<Float>(value: .zero)
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
            .withLatestFrom(output.isActive)
            .filter { $0 == false }
            .map { _ in true }
            .bind(to: output.isActive)
            .disposed(by: disposeBag)
        
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

    func handleTimerEvent(with timerUseCase: TimerUseCase) {
        let timerEvent = timerUseCase.timer
            .observe(on: MainScheduler.instance)
            .share()

        timerEvent
            .bind(to: output.timer)
            .disposed(by: disposeBag)

        timerEvent
            .map { $0.remainingSeconds }
            .filter { $0 == .zero }
            .map { _ in }
            .withUnretained(self)
            .bind { `self`, _ in
                self.stopTimer()
            }
            .disposed(by: disposeBag)
        
        timerEvent
            .map { _ in timerUseCase.progressRatio }
            .bind(to: output.progess)
            .disposed(by: disposeBag)

    func handleTimerState(with timerUseCase: TimerUseCase) {
        timerUseCase.timerState
            .withUnretained(self)
            .bind { `self`, state in
                switch state { //함수로 빼기
                case .ready:
                    self.output.isActive.accept(false)
//                    self.setToggleButtonReady()
                case .paused:
                    self.output.isActive.accept(true)
//                    self.setToggleButtonReady()
                case .running:
                    self.output.isActive.accept(true)
                    self.setToggleButtonRunning()
                case .finished:
                    self.output.isActive.accept(true)
                    self.setToggleButtonFinished()
                }
            }
            .disposed(by: disposeBag)
        
        timerUseCase.timerState
            .bind(to: output.timerState)
            .disposed(by: disposeBag)
    }
}

// MARK: - Supporting Function

private extension TimerCellViewModel {
    func toggleTimer(by isRunning: Bool) {
        switch isRunning {
        case true:
            timerUseCase.pauseTimer()
        case false:
            timerUseCase.startTimer()
        }
        output.toggleButtonIsSelected.accept(!isRunning)
    }

    func stopTimer() {
        timerUseCase.stopTimer()
        setToggleButtonFinished()
    }

    func resetTimer() {
        timerUseCase.stopTimer()
        timerUseCase.resetTimer()
        timerUseCase.removeNotification()
        setToggleButtonReady()
    }

    func changeTimer(to newTimer: Timer) {
        resetTimer()
        timerUseCase.updateTimer(to: newTimer)
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
