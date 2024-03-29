//
//  CountDownTimerUseCase.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/14.
//

import RxSwift
import RxRelay

final class CountDownTimerUseCase: TimerUseCase {
    
    let timer: BehaviorRelay<Timer>
    let timerState: BehaviorRelay<TimerState>
    
    private let timerPersistentRepository: TimerPersistentRepository
    private let timerIdentifier: UUID
    private var dispatchSourceTimer: DispatchSourceTimer? = nil
    private let disposeBag = DisposeBag()
    
    var currentTimer: Timer {
        return timer.value
    }
    
    var progressRatio: Float {
        let initialSeconds = currentTimer.totalSeconds
        let remainingSeconds = Int(round(currentTimer.remainingSeconds))
        return Float(initialSeconds - remainingSeconds) / Float(initialSeconds)
    }
    
    init(timer: Timer, timerPersistentRepository: TimerPersistentRepository) {
        self.timer = BehaviorRelay<Timer>(value: timer)
        self.timerState = BehaviorRelay<TimerState>(value: timer.state)
        self.timerPersistentRepository = timerPersistentRepository
        self.timerIdentifier = timer.identifier
        resumeIfTimerWasRunning()
    }
    
    func resumeIfTimerWasRunning() {
        timerPersistentRepository
            .findTimer(target: timerIdentifier)
            .withUnretained(self)
            .bind { `self`, timer in
                if case .running = timer.state {
                    guard let expireDate = timer.expireDate else { return }
                    self.runTimer(by: expireDate)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func startTimer() {
        if case .running = timerState.value {
            return
        }
        
        if case .finished = timerState.value {
            resetTimer()
        }
        
        UserNotificationCenterService.registerNotification(
            ringtone: timer.value.ringtone,
            remainingSeconds: currentTimer.remainingSeconds,
            timerName: currentTimer.name,
            notificationIdentifier: currentTimer.notificationIdentifier
        )
        
        let expireDate = Date(timeInterval: currentTimer.remainingSeconds, since: .now)
        timerPersistentRepository
            .updateTimer(target: timerIdentifier, state: .running, expireDate: expireDate)
            .subscribe(onCompleted: { [weak self] in
                guard let self = self else { return }
                self.runTimer(by: expireDate)
            })
            .disposed(by: disposeBag)
    }
    
    func pauseTimer() {
        if timerState.value != .running {
            return
        }
        
        removeNotification()
        dispatchSourceTimer?.suspend()
        
        timerState.accept(.paused)
        let remainingTime = Time(totalSeconds: currentTimer.totalSeconds, remainingSeconds: currentTimer.remainingSeconds)
        timerPersistentRepository.saveTimeOfTimer(target: timerIdentifier, time: remainingTime, state: .paused)
    }
    
    func stopTimer() {
        if case .paused = timerState.value {
            dispatchSourceTimer?.resume()
        }
        
        dispatchSourceTimer?.cancel()
        dispatchSourceTimer = nil
        
        timerState.accept(.finished)
        timerPersistentRepository.saveTimeOfTimer(target: timerIdentifier, state: .finished)
    }
    
    func resetTimer() {
        if case .ready = timerState.value {
            return
        }
        
        removeNotification()
        timerState.accept(.ready)
        timer.accept(Timer(timer: currentTimer, time: TimeFactory.createResetTime(of: currentTimer.time)))
        timerPersistentRepository.saveTimeOfTimer(target: timerIdentifier, time: currentTimer.time, state: .ready)
    }
    
    func updateTimer(to newTimer: Timer) {
        if newTimer.totalSeconds != currentTimer.totalSeconds {
            resetTimer()
        }
        
        if newTimer.ringtone != currentTimer.ringtone {
            UserNotificationCenterService.updateRingtone(
                for: currentTimer.notificationIdentifier,
                remainingSeconds: currentTimer.remainingSeconds,
                newRingtone: newTimer.ringtone
            )
        }
        
        timerPersistentRepository
            .updateTimer(
                target: newTimer.identifier,
                name: newTimer.name,
                tag: newTimer.tag,
                time: newTimer.time,
                ringtone: newTimer.ringtone
            )
            .subscribe(onCompleted: { [weak self] in
                guard let self = self else { return }
                self.timer.accept(newTimer)
            })
            .disposed(by: disposeBag)
    }
    
    func removeNotification() {
        if timerState.value == .paused {
            dispatchSourceTimer?.resume()
        }
        
        dispatchSourceTimer?.cancel()
        dispatchSourceTimer = nil
        
        let notificationIdentifier = currentTimer.notificationIdentifier
        UserNotificationCenterService.removeNotification(withIdentifiers: [notificationIdentifier])
    }
    
    deinit {
        stopTimer()
    }
}

// MARK: - Supporting Methods

private extension CountDownTimerUseCase {
    func runTimer(by expirationDate: Date) {
        if dispatchSourceTimer == nil {
            dispatchSourceTimer = DispatchSource.makeTimerSource(queue: .global())
        }
        
        self.timerState.accept(.running)
        dispatchSourceTimer?.resume()
        
        self.dispatchSourceTimer?.schedule(deadline: .now(), repeating: 0.1)
        self.dispatchSourceTimer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            let remainingTimeInterval = -(Date().timeIntervalSince(expirationDate))
            
            if remainingTimeInterval <= .zero {
                self.expireTimer()
                self.stopTimer()
            } else {
                let remainingTime = Time(
                    totalSeconds: self.currentTimer.totalSeconds,
                    remainingSeconds: remainingTimeInterval
                )
                self.timer.accept(Timer(timer: self.currentTimer, time: remainingTime))
            }
        }
    }
    
    func expireTimer() {
        let expiredTime = TimeFactory.createExpiredTime(of: currentTimer.time)
        timer.accept(Timer(timer: currentTimer, time: expiredTime))
        timerPersistentRepository.saveTimeOfTimer(target: timerIdentifier, time: expiredTime)
    }
}
