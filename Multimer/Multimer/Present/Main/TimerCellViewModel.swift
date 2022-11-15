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
        let restartButtonDidTap = PublishRelay<Void>()
    }
    
    struct Output {
        let timer: BehaviorRelay<Timer>
        let time = PublishRelay<Time>()
        let toggleButtonIsSelected = BehaviorRelay<Bool>(value: false)
        let toggleButtonIsHidden = BehaviorRelay<Bool>(value: false)
        let restartButtonIsHidden = BehaviorRelay<Bool>(value: true)
        let timerSettingViewModel = PublishRelay<TimerSettingViewModel>()
    }
    
    let input = Input()
    let output: Output
    let timerUseCase: TimerUseCase
    
    let identifier = UUID()
    private let disposeBag = DisposeBag()
    
    init(timer: Timer, timerUseCase: TimerUseCase) {
        self.timerUseCase = timerUseCase
        self.output = Output(timer: BehaviorRelay<Timer>(value: timer))
        
        // MARK: - Handle CellDidLoad from Input
        
        input.cellDidLoad
            .map { timerUseCase.time.value }
            .bind(to: output.time)
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
        
        // MARK: - Handle Time from UseCase
        
        timerUseCase.time
            .bind(to: output.time)
            .disposed(by: disposeBag)
        
        let timerExpired = timerUseCase.time
            .filter { $0.totalSeconds == .zero }
            .map { _ in }
            .share()
        
        timerExpired
            .bind(onNext: timerUseCase.stopTimer)
            .disposed(by: disposeBag)
        
        // MARK: - Handle RestartButtonDidTap from Input
        
        input.restartButtonDidTap
            .withUnretained(self)
            .bind { `self`, _ in
                self.output.toggleButtonIsHidden.accept(false)
                self.output.restartButtonIsHidden.accept(true)
//            self.output.time.onNext(self.initialTime)
//            print(self.initialTime)
            }
            .disposed(by: disposeBag)
        
        // MARK: - Handle CellDidTap from Input
        
        let settingViewModel = input.cellDidTap
            .withLatestFrom(output.timer)
            .map { TimerSettingViewModel(timer: $0) }
            .share()
        
        settingViewModel
            .bind(to: output.timerSettingViewModel)
            .disposed(by: disposeBag)
        
        // MARK: - Handle NewTimer from SettingViewModel Output
        
        let changedTimer = settingViewModel
            .flatMapLatest { $0.output.newTimer }
            .share()
        
        changedTimer
            .map { _ in }
            .bind(onNext: timerUseCase.stopTimer)
            .disposed(by: disposeBag)
        
        changedTimer
            .map { $0.time }
            .bind(to: output.time)
            .disposed(by: disposeBag)
        
        changedTimer
            .map { $0.time }
            .bind(to: timerUseCase.time)
            .disposed(by: disposeBag)
        
        changedTimer
            .map { _ in false }
            .bind(to: output.toggleButtonIsSelected)
            .disposed(by: disposeBag)
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
