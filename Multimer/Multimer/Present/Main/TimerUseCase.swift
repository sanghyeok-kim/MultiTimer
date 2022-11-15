//
//  TimerUseCase.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/14.
//

import RxSwift
import RxRelay

final class TimerUseCase {
    
    private var timerState: TimerState = .finished
    private var dispatchSourceTimer: DispatchSourceTimer? = nil
    let time: BehaviorRelay<Time>
    
    init(time: Time) {
        self.time = BehaviorRelay<Time>(value: time)
    }
    
    func startTimer() {
        if dispatchSourceTimer == nil {
            dispatchSourceTimer = DispatchSource.makeTimerSource(queue: .global())
        }
        
        dispatchSourceTimer?.schedule(deadline: .now() + 1, repeating: 1)
        dispatchSourceTimer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            let currentTime = self.time.value
            let newTime = Time(totalSeconds: currentTime.totalSeconds - 1)
            self.time.accept(newTime)
        }
        
        dispatchSourceTimer?.resume()
        timerState = .running
    }
    
    func pauseTimer() {
        dispatchSourceTimer?.suspend()
        timerState = .paused
    }
    
    func stopTimer() {
        if timerState == .paused {
            dispatchSourceTimer?.resume()
        }
        
        dispatchSourceTimer?.cancel()
        timerState = .finished
        dispatchSourceTimer = nil
    }
}

private extension TimerUseCase {
    enum TimerState {
        case running
        case paused
        case finished
    }
}
