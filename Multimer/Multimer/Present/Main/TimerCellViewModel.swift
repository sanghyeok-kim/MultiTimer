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
        let cellDidLoad = PublishRelay<Void>()
        let cellDidTap = PublishRelay<Void>()
        let toggleButtonDidTap = PublishRelay<Void>()
        let resetButtonDidTap = PublishRelay<Void>()
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
    
    let identifier = UUID()
    private let disposeBag = DisposeBag()
    
    init(timerUseCase: TimerUseCase) {
        self.timerUseCase = timerUseCase
        
        // MARK: - Handle Timer from UseCase
        
        let timerEvent = timerUseCase.timer
            .observe(on: MainScheduler.instance)
            .share()
        
        timerEvent
            .bind(to: output.timer)
            .disposed(by: disposeBag)
        
        let timerExpired = timerEvent
            .map { $0.time.totalSeconds }
            .filter { $0 == .zero }
            .map { _ in }
            .share()
        
        timerExpired
            .bind(onNext: timerUseCase.stopTimer)
            .disposed(by: disposeBag)
        
        timerExpired
            .withUnretained(self)
            .bind { `self`, _ in
                self.output.restartButtonIsHidden.accept(false)
                self.output.toggleButtonIsHidden.accept(true)
                self.output.toggleButtonIsSelected.accept(false)
            }
            .disposed(by: disposeBag)
        
        // MARK: - Handle ToggleButtonDidTap from Input
        
        let isTimerRunning = input.toggleButtonDidTap
            .withLatestFrom(output.toggleButtonIsSelected)
            .share()
        
        isTimerRunning
            .filter { $0 }
            .map { _ in }
            .bind(onNext: timerUseCase.pauseTimer)
            .disposed(by: disposeBag)
        
        isTimerRunning
            .filter { !$0 }
            .map { _ in }
            .bind(onNext: timerUseCase.startTimer)
            .disposed(by: disposeBag)
        
        isTimerRunning
            .map { !$0 }
            .bind(to: output.toggleButtonIsSelected)
            .disposed(by: disposeBag)
        
        
        // MARK: - Handle ResetButtonDidTap from Input
        
        input.resetButtonDidTap
            .withUnretained(self)
            .bind { `self`, _ in
                self.output.restartButtonIsHidden.accept(true)
                self.output.toggleButtonIsHidden.accept(false)
                timerUseCase.resetTimer()
            }
            .disposed(by: disposeBag)
        
        // MARK: - Handle CellDidTap from Input
        
        let settingViewModel = input.cellDidTap
            .map { TimerSettingViewModel(timer: timerUseCase.initialTimer) }
            .share()
        
        settingViewModel
            .bind(to: output.timerSettingViewModel)
            .disposed(by: disposeBag)
        
        // MARK: - Handle NewTimer from SettingViewModel Output
        
        let changedTimer = settingViewModel
            .flatMapLatest { $0.output.newTimer }
            .share()
        
        changedTimer
            .bind(onNext: timerUseCase.changeTimer)
            .disposed(by: disposeBag)
        
        changedTimer
            .map { _ in false }
            .bind(to: output.toggleButtonIsSelected)
            .disposed(by: disposeBag)
    }
    
    deinit {
        timerUseCase.stopTimer() // TODO: cell 삭제해도 deinit 안되는거 고치기
    }
}

extension TimerCellViewModel: Hashable {
    static func == (lhs: TimerCellViewModel, rhs: TimerCellViewModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
