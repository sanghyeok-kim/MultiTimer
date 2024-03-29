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
        let progessRatio = BehaviorRelay<Float>(value: .zero)
        let isActive = BehaviorRelay<Bool>(value: false)
        let timerState = PublishRelay<TimerState>()
        let initialTimeLabelIsHidden = BehaviorRelay<Bool>(value: true)
        let cellCanTap = BehaviorRelay<Bool>(value: true)
    }
    
    let input = Input()
    let output = Output()
    
    let identifier: UUID
    private weak var coordinator: HomeCoordinator?
    private let timerUseCase: TimerUseCase
    private let disposeBag = DisposeBag()
    
    init(identifier: UUID, coordinator: HomeCoordinator?, timerUseCase: TimerUseCase) {
        self.identifier = identifier
        self.coordinator = coordinator
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
    
    func resetTimer() {
        timerUseCase.resetTimer()
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
        let editedTimerRelay = PublishRelay<Timer>()
        
        input.cellDidTap
            .bind(with: self) { `self`, _ in
                self.coordinator?.coordinate(by: .showTimerEditScene(
                    initialTimer: self.timerUseCase.currentTimer,
                    editedTimerRelay: editedTimerRelay
                ))
            }
            .disposed(by: disposeBag)
        
        editedTimerRelay
            .bind(onNext: timerUseCase.updateTimer)
            .disposed(by: disposeBag)
    }
    
    func handleIsActive(with timerUseCase: TimerUseCase) {
        output.isActive
            .withLatestFrom(timerUseCase.timer) { ($0, $1) }
            .map { isActive, timer  -> Bool in
                return timer.type == .countDown ? !isActive : true
            }
            .distinctUntilChanged()
            .bind(to: output.initialTimeLabelIsHidden)
            .disposed(by: disposeBag)
    }
    
    func handleTimerEvent(with timerUseCase: TimerUseCase) {
        let timerEvent = timerUseCase.timer
            .observe(on: MainScheduler.asyncInstance)
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
