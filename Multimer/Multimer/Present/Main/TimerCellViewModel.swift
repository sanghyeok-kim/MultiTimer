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
        let toggleButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let timer: BehaviorRelay<Timer>
        let time: BehaviorRelay<Time>
        let toggleButtonIsSelected = BehaviorRelay<Bool>(value: false)
    }
    
    private let output: Output
    
    init(timer: Timer) {
        output = Output(
            timer: BehaviorRelay<Timer>(value: timer),
            time: BehaviorRelay<Time>(value: timer.time)
        )
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let toggleButtonDidTapEvent = input.toggleButtonDidTap.share()
        
        toggleButtonDidTapEvent
            .scan(false) { lastState, newState in
                !lastState
            }
            .bind(to: output.toggleButtonIsSelected)
            .disposed(by: disposeBag)
        
        return output
    }
}
