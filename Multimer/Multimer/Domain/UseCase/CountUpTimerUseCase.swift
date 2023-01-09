//
//  CountUpTimerUseCase.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/21.
//

import RxSwift
import RxRelay

final class CountUpTimerUseCase: TimerUseCase {
    
    let timer: BehaviorRelay<Timer>
    let timerState: BehaviorRelay<TimerState>
    
    private let timerPersistentRepository: TimerPersistentRepository
    private let timerIdentifier: UUID
    private var dispatchSourceTimer: DispatchSourceTimer? = nil
    private let disposeBag = DisposeBag()
    
    var currentTimer: Timer {
        return timer.value
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
                    guard let startDate = timer.startDate else { return }
                    self.runTimer(by: startDate)
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
        
        let startDate = Date()
        timerPersistentRepository
            .updateTimer(target: timerIdentifier, state: .running, startDate: startDate)
            .subscribe(onCompleted: { [weak self] in
                guard let self = self else { return }
                self.runTimer(by: startDate)
            })
            .disposed(by: disposeBag)
    }
    
    func pauseTimer() {
        if timerState.value != .running {
            return
        }
        
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
    }
    
    func resetTimer() {
        if case .ready = timerState.value {
            return
        }
        
        stopTimer()
        
        timerState.accept(.ready)
        let defaultTime = TimeFactory.createDefaultTime()
        timer.accept(Timer(timer: currentTimer, time: defaultTime))
        timerPersistentRepository.saveTimeOfTimer(target: timerIdentifier, time: defaultTime, state: .ready)
    }
    
    func updateTimer(to newTimer: Timer) {
        timerPersistentRepository
            .updateTimer(target: newTimer.identifier, name: newTimer.name, tag: newTimer.tag)
            .subscribe(onCompleted: { [weak self] in
                guard let self = self else { return }
                self.timer.accept(newTimer)
            })
            .disposed(by: disposeBag)
    }
    
    private func runTimer(by startDate: Date) {
        if dispatchSourceTimer == nil {
            dispatchSourceTimer = DispatchSource.makeTimerSource(queue: .global())
        }
        
        self.timerState.accept(.running)
        dispatchSourceTimer?.resume()
        
        let elapsedTime = self.currentTimer.remainingSeconds
        
        self.dispatchSourceTimer?.schedule(deadline: .now(), repeating: 0.1)
        self.dispatchSourceTimer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            
            let timeIntervalSinceStartDate = Date().timeIntervalSince(startDate) + elapsedTime
            
            let totalElapsedTime = Time(totalSeconds: Int(timeIntervalSinceStartDate), remainingSeconds: timeIntervalSinceStartDate)
            self.timer.accept(Timer(timer: self.currentTimer, time: totalElapsedTime))
        }
    }
    
    deinit {
        stopTimer()
    }
}
