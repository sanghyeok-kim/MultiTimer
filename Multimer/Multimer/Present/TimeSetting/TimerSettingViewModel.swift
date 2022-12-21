//
//  TimerSettingViewModel.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/07.
//

import RxSwift
import RxRelay

final class TimerSettingViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let tagDidSelect = PublishRelay<Tag?>()
        let nameTextFieldDidEdit = PublishRelay<String>()
        let timePickerViewDidEdit = PublishRelay<Time>()
        let cancelButtonDidTap = PublishRelay<Void>()
        let completeButtonDidTap = PublishRelay<Void>()
    }
    
    struct Output {
        let nameTextFieldContents = PublishRelay<String>()
        let nameTextFieldExceedMaxLength = PublishRelay<Bool>()
        let completeButtonEnable = PublishRelay<Bool>()
        let timer: BehaviorRelay<Timer>
        let newTimer = PublishRelay<Timer>()
        let timePickerViewIsHidden = PublishRelay<Bool>()
        let exitScene = PublishRelay<Void>()
    }
    
    let output: Output
    let input = Input()
    
    private let disposeBag = DisposeBag()
    
    init(timer: Timer) {
        self.output = Output(timer: BehaviorRelay<Timer>(value: timer))
        
        input.cancelButtonDidTap
            .bind(to: output.exitScene)
            .disposed(by: disposeBag)
        
        output.newTimer
            .map { _ in }
            .bind(to: output.exitScene)
            .disposed(by: disposeBag)
        
        // MARK: - Timer 초기값을 한 번 보내줌
        input.viewDidLoad
            .map { timer.name }
            .bind(to: input.nameTextFieldDidEdit)
            .disposed(by: disposeBag)
        input.viewDidLoad
            .map { timer.time.dividedSeconds }
            .bind(to: input.timePickerViewDidEdit)
            .disposed(by: disposeBag)
        
        
        let newTimer = Observable
            .combineLatest(
                input.nameTextFieldDidEdit,
                input.tagDidSelect,
                input.timePickerViewDidEdit
            )
            .map { (name, tag, time) in
                Timer(
                    identifier: timer.identifier,
                    name: name,
                    tag: tag,
                    time: time
                )
            }
            .share()
        
        newTimer
            .withLatestFrom(output.timer) { newTimer, currentTimer in
                switch newTimer.type {
                case .countDown:
                    return currentTimer != newTimer && newTimer.totalSeconds > 0
                case .countUp:
                    return true
                }
            }
            .bind(to: output.completeButtonEnable)
            .disposed(by: disposeBag)
        
        input.completeButtonDidTap
            .withLatestFrom(newTimer)
            .bind(to: output.newTimer)
            .disposed(by: disposeBag)
    }
}
