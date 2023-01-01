//
//  TimerCreateViewModel.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/21.
//

import RxSwift
import RxRelay

final class TimerCreateViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let tagDidSelect = PublishRelay<Tag?>()
        let nameTextFieldDidEdit = PublishRelay<String>()
        let timePickerViewDidEdit = BehaviorRelay<Time>(value: TimeFactory.createDefaultTime())
        let cancelButtonDidTap = PublishRelay<Void>()
        let completeButtonDidTap = PublishRelay<Void>()
        let selectedTimerType = PublishRelay<TimerType>()
    }
    
    struct Output {
        let completeButtonEnable = PublishRelay<Bool>()
        let timer: BehaviorRelay<Timer>
        let newTimer = PublishRelay<Timer>()
        let timePickerViewIsHidden = PublishRelay<Bool>()
        let exitScene = PublishRelay<Void>()
        let placeholder = BehaviorRelay<String>(value: "")
    }
    
    let output: Output
    let input = Input()
    
    private let disposeBag = DisposeBag()
    
    init(timer: Timer) {
        self.output = Output(timer: BehaviorRelay<Timer>(value: timer))
        
        let selectedTimerType = input.selectedTimerType.share()
        
        selectedTimerType
            .map { !$0.shouldSetTime }
            .bind(to: output.timePickerViewIsHidden)
            .disposed(by: disposeBag)
        
        selectedTimerType
            .map { $0.placeholder }
            .bind(to: output.placeholder)
            .disposed(by: disposeBag)
        
        let newTimer = Observable
            .combineLatest(
                input.nameTextFieldDidEdit,
                input.tagDidSelect,
                input.timePickerViewDidEdit,
                input.selectedTimerType
            )
            .map { (name, tag, time, type) in
                Timer(
                    identifier: timer.identifier,
                    name: name,
                    time: type == .countDown ? time : TimeFactory.createDefaultTime(),
                    type: type
                )
            }
            .share()
        
        newTimer
            .map { timer in
                switch timer.type {
                case .countDown:
                    return !timer.name.isEmpty && timer.totalSeconds > 0
                case .countUp:
                    return !timer.name.isEmpty
                }
            }
            .bind(to: output.completeButtonEnable)
            .disposed(by: disposeBag)
        
        input.completeButtonDidTap
            .withLatestFrom(newTimer)
            .bind(to: output.newTimer)
            .disposed(by: disposeBag)
        
        output.newTimer
            .map { _ in }
            .bind(to: output.exitScene)
            .disposed(by: disposeBag)
        
        input.cancelButtonDidTap
            .bind(to: output.exitScene)
            .disposed(by: disposeBag)
    }
}
