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
        let cellDidTap = PublishRelay<Void>()
        let cellDidSelect = BehaviorRelay<Bool>(value: false)
        let toggleButtonDidTap = PublishRelay<Void>()
        let resetButtonDidTap = PublishRelay<Void>()
    }
    
    struct Output {
        let timer = BehaviorRelay<Timer>(value: Timer())
        let toggleButtonIsSelected = BehaviorRelay<Bool>(value: false)
        let toggleButtonIsHidden = BehaviorRelay<Bool>(value: false)
        let resetButtonIsHidden = BehaviorRelay<Bool>(value: true)
        let timerSettingViewModel = PublishRelay<TimerSettingViewModel>()
        let progessRatio = BehaviorRelay<Float>(value: .zero)
        let isActive = BehaviorRelay<Bool>(value: false)
        let timerState = PublishRelay<TimerState>()
        let initialTimeLabelIsHidden = PublishRelay<Bool>()
        let cellCanTap = PublishRelay<Bool>()
    }
    
    let input = Input()
    let output = Output()
    
    let identifier: UUID
    private let timerUseCase: TimerUseCase
    private let disposeBag = DisposeBag()
    
    init(identifier: UUID, timerUseCase: TimerUseCase) {
        self.identifier = identifier
        self.timerUseCase = timerUseCase
        
        // MARK: - Handle Event from Input
        
        handleToggleButtonDidTap()
        handleResetButtonDidTap()
        handleCellDidTap(with: timerUseCase)
        handleIsActive(with: timerUseCase)
        
        // MARK: - Handle Event from UseCase
        
        handleTimerState(with: timerUseCase)
        handleTimerEvent(with: timerUseCase)
    }
}

// MARK: - Providing Methods

extension TimerCellViewModel {
    func removeNotification() {
        timerUseCase.removeNotification()
    }
    
    func controlTimerIfSelected(by buttonType: EditViewButtonType) {
        switch buttonType {
        case .start:
            timerUseCase.startTimer()
        case .pause:
            timerUseCase.pauseTimer()
        case .reset:
            timerUseCase.resetTimer()
        }
    }
    
    func enableCellTapButton(by isEditing: Bool) {
        output.cellCanTap.accept(isEditing)
    }
}

// MARK: - Event Handling Methods

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
            .bind(onNext: timerUseCase.resetTimer)
            .disposed(by: disposeBag)
    }
    
    func handleCellDidTap(with timerUseCase: TimerUseCase) {
        let settingViewModel = input.cellDidTap
            .map { TimerSettingViewModel(timer: timerUseCase.currentTimer) }
            .share()
        
        settingViewModel
            .bind(to: output.timerSettingViewModel)
            .disposed(by: disposeBag)
        
        settingViewModel
            .flatMapLatest { $0.output.newTimer }
            .bind(onNext: timerUseCase.updateTimer)
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
            .map { _ in timerUseCase.progressRatio }
            .distinctUntilChanged()
            .bind(to: output.progessRatio)
            .disposed(by: disposeBag)
    }
    
    func handleTimerState(with timerUseCase: TimerUseCase) {
        timerUseCase.timerState
            .withUnretained(self)
            .bind { `self`, state in
                switch state {
                case .ready:
                    self.output.isActive.accept(false)
                    self.setToggleButtonReady()
                case .paused:
                    self.output.isActive.accept(true)
                    self.setToggleButtonPaused()
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

// MARK: - Helper Methods

private extension TimerCellViewModel {
    func setToggleButtonReady() {
        output.toggleButtonIsSelected.accept(false)
        output.toggleButtonIsHidden.accept(false)
        output.resetButtonIsHidden.accept(true)
    }
    
    func setToggleButtonRunning() {
        output.toggleButtonIsSelected.accept(true)
    }
    
    func setToggleButtonPaused() {
        output.toggleButtonIsSelected.accept(false)
    }
    
    func setToggleButtonFinished() {
        output.toggleButtonIsSelected.accept(false)
        output.resetButtonIsHidden.accept(false)
    }
    
    func toggleTimer(by isRunning: Bool) {
        switch isRunning {
        case true:
            timerUseCase.pauseTimer()
        case false:
            timerUseCase.startTimer()
        }
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
