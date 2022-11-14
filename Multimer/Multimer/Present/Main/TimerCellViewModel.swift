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
        let toggleButtonDidTap = PublishRelay<Void>()
        let restartButtonDidTap = PublishRelay<Void>()
    }
    
    struct Output {
        let timer: BehaviorRelay<Timer>
        let time: BehaviorRelay<Time> // FIXME: Relay -> onComplete 처리 가능하도록 변경
        let toggleButtonIsSelected = BehaviorRelay<Bool>(value: false)
        let toggleButtonIsHidden = BehaviorRelay<Bool>(value: false)
        let restartButtonIsHidden = BehaviorRelay<Bool>(value: true)
        let timerSettingViewModel = PublishRelay<TimerSettingViewModel>()
    }
    
    let input = Input()
    let output: Output
    
    let identifier = UUID()
    private let disposeBag = DisposeBag()
    private var remainingSeconds: Int
    
    init(timer: Timer, timerUseCase: TimerUseCase) {
        output = Output(
            timer: BehaviorRelay<Timer>(value: timer),
            time: BehaviorRelay<Time>(value: timer.time)
        )
        self.remainingSeconds = timer.time.totalSeconds
        
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
        
        // MARK: - Handle TimeIntervalEvent from UseCase
        
        //timerIntervalEvent에서 이벤트 발생시 -> currentTotalSeconds에서 1을 뺀 값을 방출하는 timerEvent 생성
        let timerEvent = timerUseCase.timeIntervalEvent
            .withUnretained(self) { `self`, _ in
                self.remainingSeconds - 1
            }
            .share()
        
        //timerIntervalEvent에서 이벤트 발생시 -> currentTotalSeconds를 갱신하고 time을 output으로 전달
        timerEvent
            .map { Time(totalSeconds: $0) }
            .withUnretained(self) { `self`, time -> Time in
                self.remainingSeconds = time.totalSeconds
                return time
            }
            .bind(to: output.time)
            .disposed(by: disposeBag)
        
        //timerIntervalEvent에서 이벤트 발생시 -> 방출된 값이 0이 되면 타이머 invalidate
        timerEvent
            .filter { $0 == .zero }
            .map { _ in }
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
            .withUnretained(self)
            .do { `self`, timer in
                self.remainingSeconds = timer.time.totalSeconds
            }
            .map { $0.1 }
            .bind(to: output.timer)
            .disposed(by: disposeBag)
        
        changedTimer
            .map { $0.time }
            .bind(to: output.time)
            .disposed(by: disposeBag)
        
        changedTimer
            .map { _ in }
            .bind(onNext: timerUseCase.stopTimer)
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
