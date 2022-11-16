//
//  TimerUseCase.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/14.
//

import RxSwift
import RxRelay

final class TimerUseCase {
    
    let timer: BehaviorRelay<Timer>
    var initialTimer: Timer
    private var timerState: TimerState = .ready
    private var dispatchSourceTimer: DispatchSourceTimer? = nil
    private let timerNotificationIdentifier = UUID()
    
    var currentTimer: Timer {
        return timer.value
    }
    
    init(timer: Timer) {
        self.timer = BehaviorRelay<Timer>(value: timer)
        self.initialTimer = timer
    }
    
    func startTimer() {
        let content = UNMutableNotificationContent()
        content.title = "타이머 종료"
        content.body = "\(timer.value.name) 종료"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(currentTimer.totalSeconds), repeats: false)
        let request = UNNotificationRequest(identifier: "\(timerNotificationIdentifier)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        let startTime = Date()
        let initialSeconds = currentTimer.totalSeconds
        
        if dispatchSourceTimer == nil {
            dispatchSourceTimer = DispatchSource.makeTimerSource(queue: .global())
        }
        
        dispatchSourceTimer?.schedule(deadline: .now() + 1, repeating: 1)
        dispatchSourceTimer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            
            //2. 1초마다 (startTime - 다시 계산한 현재 시간) 차이 계산해서 elapsedTime에 저장
            let elapsedTime = Int(Date().timeIntervalSince(startTime))
            
            if elapsedTime >= initialSeconds {
                self.timer.accept(Timer(timer: self.currentTimer, time: Time()))
            } else {
                let newTime = Time(totalSeconds: initialSeconds - elapsedTime)
                self.timer.accept(Timer(timer: self.currentTimer, time: newTime))
            }
        }
        
        dispatchSourceTimer?.resume()
        timerState = .running
    }
    
    func pauseTimer() {
        dispatchSourceTimer?.suspend()
        timerState = .paused
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(timerNotificationIdentifier)"])
    }
    
    func stopTimer() {
        if timerState == .paused {
            dispatchSourceTimer?.resume()
        }
        
        dispatchSourceTimer?.cancel()
        timerState = .finished
        dispatchSourceTimer = nil
    }
    
    func resetTimer() {
        stopTimer()
        self.timer.accept(initialTimer)
        timerState = .ready
    }
    
    func changeTimer(with newTimer: Timer) {
        stopTimer()
        timer.accept(newTimer)
        initialTimer = newTimer
    }
}

private extension TimerUseCase {
    enum TimerState {
        case ready
        case running
        case paused
        case finished
    }
}
