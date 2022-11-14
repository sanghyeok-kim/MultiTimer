//
//  TimerUseCase.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/14.
//

import RxSwift
import RxRelay

final class TimerUseCase {
    
    private var timerState: TimerState = .stopped
    private var timer: DispatchSourceTimer? = nil
    let timeIntervalEvent = PublishRelay<Void>()
    
    func startTimer() {
        if timer == nil {
            timer = DispatchSource.makeTimerSource(queue: .global(qos: .background))
        }
        
        timer?.schedule(deadline: .now() + 1, repeating: 1)
        timer?.setEventHandler { [weak self] in
            self?.timeIntervalEvent.accept(())
        }
        
        timer?.resume()
        timerState = .running
    }
    
    func pauseTimer() {
        timer?.suspend()
        timerState = .paused
    }
    
    func stopTimer() {
        //suspended일 때 nil을 대입하면 런타임 에러
        if timerState == .paused {
            timer?.resume()
        }
        
        timer?.cancel()
        timerState = .stopped
        timer = nil
    }
}

private extension TimerUseCase {
    enum TimerState {
        case running
        case paused
        case stopped
    }
}
