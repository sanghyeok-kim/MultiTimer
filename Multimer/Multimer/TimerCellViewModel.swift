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
    }
    
    private let timer: Timer
    private let disposeBag = DisposeBag()
    
    init(timer: Timer) {
        self.timer = timer
    }
    
    func transform(from input: Input) -> Output {
        let output = Output(timer: BehaviorRelay<Timer>(value: self.timer))
        
        return output
    }
}
