//
//  TimerUseCase.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/21.
//

import RxSwift
import RxRelay

protocol TimerUseCase {
    var timer: BehaviorRelay<Timer> { get }
    var timerState: BehaviorRelay<TimerState> { get }
    var currentTimer: Timer { get }
    var progressRatio: Float { get }
    
    func startTimer()
    func pauseTimer()
    func resetTimer()
    func updateTimer(to newTimer: Timer)
    func removeNotification()
}

extension TimerUseCase {
    var progressRatio: Float { .zero }
    func removeNotification() { }
}
