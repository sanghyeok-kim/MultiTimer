//
//  TimerEditingReactor.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/07.
//

import ReactorKit
import RxRelay

final class TimerEditingReactor: Reactor {
    
    enum Action {
        case cancelButtonDidTap
        case completeButtonDidTap
        case nameTextFieldDidEdit(String)
        case tagDidSelect(Tag?)
        case timePickerViewDidEdit(Time)
        case viewDidLoad
        case ringtoneButtonDidTap
    }
    
    enum Mutation {
        case setTimePickerViewIsHidden(Bool)
        case editTimer(Timer)
        case updateSelectedRingtone(Ringtone)
        case setTimerNamePlaceholder(String)
    }
    
    struct State {
        var editedTimer: Timer
        var initialTimer: Timer
        var isCompleteButtonEnable: Bool = false
        var isTimePickerViewHidden: Bool = false
        var shouldExitScene: Bool = false
        var timerNamePlaceholder: String?
    }
    
    let initialState: State
    
    private weak var coordinator: HomeCoordinator?
    private let editedTimerRelay: PublishRelay<Timer>
    private let selectedRingtoneRelay: BehaviorRelay<Ringtone>
    
    init(
        initialTimer: Timer,
        coordinator: HomeCoordinator?,
        editedTimerRelay: PublishRelay<Timer>
    ) {
        initialState = State(editedTimer: initialTimer, initialTimer: initialTimer)
        self.coordinator = coordinator
        self.editedTimerRelay = editedTimerRelay
        self.selectedRingtoneRelay = BehaviorRelay<Ringtone>(value: initialTimer.ringtone ?? .default1)
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
            let placeholder = initialTimer.name.isEmpty ? initialTimer.type.placeholder : initialTimer.name
            return .concat(
                .just(.setTimePickerViewIsHidden(isTimePickerViewHidden)),
                .just(.setTimerNamePlaceholder(placeholder))
            )
            
        case .ringtoneButtonDidTap:
            return showRingtoneSelectScene(selectedRingtoneRelay: selectedRingtoneRelay)
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
                initialTimer: state.initialTimer,
                newTimer: newState.editedTimer
            )
            
        case .updateSelectedRingtone(let ringtone):
            newState.editedTimer.ringtone = ringtone
            newState.isCompleteButtonEnable = validateCompleteButtonIsEnable(
                initialTimer: state.initialTimer,
                newTimer: newState.editedTimer
            )
            
        case .setTimerNamePlaceholder(let placeholder):
            newState.timerNamePlaceholder = placeholder
        }
        return newState
    }
}

// MARK: - Supporting Methods

private extension TimerEditingReactor {
    func validateCompleteButtonIsEnable(initialTimer: Timer, newTimer: Timer) -> Bool {
        switch newTimer.type {
        case .countDown:
            return initialTimer != newTimer && newTimer.totalSeconds > 0
        case .countUp:
            return initialTimer != newTimer
        }
    }
}

// MARK: - Side Effect Methods

private extension TimerEditingReactor {
    func exitScene() -> Observable<Mutation> {
        coordinator?.coordinate(by: .finishTimerEditScene)
        return .empty()
    }
    
    func showRingtoneSelectScene(selectedRingtoneRelay: BehaviorRelay<Ringtone>) -> Observable<Mutation> {
        coordinator?.coordinate(by: .showRingtoneSelectScene(selectedRingtoneRelay: selectedRingtoneRelay))
        return selectedRingtoneRelay.map { Mutation.updateSelectedRingtone($0) }
    }
    
    func acceptEditedTimerRelay(editedTimer: Timer) -> Observable<Mutation> {
        editedTimerRelay.accept(editedTimer)
        return .empty()
    }
}
