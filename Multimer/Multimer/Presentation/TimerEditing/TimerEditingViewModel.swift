//
//  TimerEditingViewModel.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/07.
//

import ReactorKit
import RxRelay

final class TimerEditingViewModel: Reactor {
    
    enum Action {
        case cancelButtonDidTap
        case completeButtonDidTap
        case nameTextFieldDidEdit(String)
        case tagDidSelect(Tag?)
        case timePickerViewDidEdit(Time)
        case viewDidLoad
    }
    
    enum Mutation {
        case setTimePickerViewIsHidden(Bool)
        case editTimer(Timer)
    }
    
    struct State {
        var editedTimer: Timer
        var initialTimer: Timer
        var isCompleteButtonEnable: Bool = false
        var isTimePickerViewHidden: Bool = false
        var shouldExitScene: Bool = false
    }
    
    let initialState: State
    
    private weak var coordinator: HomeCoordinator?
    private let editedTimerRelay: PublishRelay<Timer>
    
    init(
        initialTimer: Timer,
        coordinator: HomeCoordinator?,
        editedTimerRelay: PublishRelay<Timer>
    ) {
        initialState = State(editedTimer: initialTimer, initialTimer: initialTimer)
        self.coordinator = coordinator
        self.editedTimerRelay = editedTimerRelay
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .cancelButtonDidTap:
            return exitScene()
            
        case .completeButtonDidTap:
            let editedTimer = currentState.editedTimer
            return .concat(
                acceptEditedTimerRelay(editedTimer: editedTimer),
                exitScene()
            )
            
        case .nameTextFieldDidEdit(let newName):
            var editedTimer = currentState.editedTimer
            editedTimer.name = newName
            return .just(.editTimer(editedTimer))
            
        case .tagDidSelect(let newTag):
            var editedTimer = currentState.editedTimer
            editedTimer.tag = newTag
            return .just(.editTimer(editedTimer))
            
        case .timePickerViewDidEdit(let newTime):
            var editedTimer = currentState.editedTimer
            editedTimer.time = newTime
            return .just(.editTimer(editedTimer))
            
        case .viewDidLoad:
            let initialTimer = currentState.initialTimer
            let isTimePickerViewHidden = !initialTimer.type.shouldSetTime
            return .just(.setTimePickerViewIsHidden(isTimePickerViewHidden))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setTimePickerViewIsHidden(let isHidden):
            newState.isTimePickerViewHidden = isHidden
            
        case .editTimer(let editedTimer):
            newState.editedTimer = editedTimer
            newState.isCompleteButtonEnable = validateCompleteButtonIsEnable(
                currentTimer: state.initialTimer,
                newTimer: editedTimer
            )
        }
        return newState
    }
}

// MARK: - Supporting Methods

private extension TimerEditingViewModel {
    func validateCompleteButtonIsEnable(currentTimer: Timer, newTimer: Timer) -> Bool {
        switch newTimer.type {
        case .countDown:
            return currentTimer != newTimer && newTimer.totalSeconds > 0
        case .countUp:
            return currentTimer != newTimer
        }
    }
}

// MARK: - Side Effect Methods

private extension TimerEditingViewModel {
    func exitScene() -> Observable<Mutation> {
        coordinator?.coordinate(by: .finishTimerEditScene)
        return .empty()
    }
    
    func acceptEditedTimerRelay(editedTimer: Timer) -> Observable<Mutation> {
        editedTimerRelay.accept(editedTimer)
        return .empty()
    }
}
