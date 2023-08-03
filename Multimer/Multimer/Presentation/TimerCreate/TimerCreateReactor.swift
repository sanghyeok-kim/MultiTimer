//
//  TimerCreateReactor.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/21.
//

import ReactorKit
import RxRelay

final class TimerCreateReactor: Reactor {
    
    enum Action {
        case cancelButtonDidTap
        case completeButtonDidTap
        case defaultNameBarButtonDidTap
        case nameTextFieldDidEdit(String)
        case tagDidSelect(Tag?)
        case timePickerViewDidEdit(Time)
        case timerTypeDidSelect(TimerType)
        case ringtoneButtonDidTap
    }
    
    enum Mutation {
        case setTimePickerViewHidden(Bool)
        case setTimer(Timer)
        case setTimerNamePlaceholder(String)
        case updateSelectedRingtone(Ringtone)
    }
    
    struct State {
        var isCompleteButtonEnabled: Bool = false
        var isTimePickerViewHidden: Bool = false
        var timer = Timer(tag: Tag(isSelected: true, color: .label))
        var timerNamePlaceholder: String = ""
        var selectedRingtone: Ringtone = .default1
    }
    
    let initialState = State()
    
    private weak var coordinator: HomeCoordinator?
    private let createdTimerRelay: PublishRelay<Timer>
    private let selectedRingtoneRelay = BehaviorRelay<Ringtone>(value: .default1)
    
    init(coordinator: HomeCoordinator?, createdTimerRelay: PublishRelay<Timer>) {
        self.coordinator = coordinator
        self.createdTimerRelay = createdTimerRelay
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .cancelButtonDidTap:
            return exitScene()
            
        case .completeButtonDidTap:
            var createdTimer = currentState.timer
            if createdTimer.type == .countUp {
                createdTimer.time = TimeFactory.createDefaultTime()
            }
            return .concat(
                acceptCreatedTimerRelay(createdTimer: createdTimer),
                exitScene()
            )
            
        case .defaultNameBarButtonDidTap:
            var timer = currentState.timer
            let defaultName = timer.type.title
            timer.name = defaultName
            return .just(.setTimer(timer))
            
        case .nameTextFieldDidEdit(let newName):
            var timer = currentState.timer
            timer.name = newName
            return .just(.setTimer(timer))
            
        case .tagDidSelect(let newTag):
            var timer = currentState.timer
            timer.tag = newTag
            return .just(.setTimer(timer))
            
        case .timePickerViewDidEdit(let newTime):
            var timer = currentState.timer
            timer.time = newTime
            return .just(.setTimer(timer))
            
        case .timerTypeDidSelect(let selectedType):
            var timer = currentState.timer
            timer.type = selectedType
            return .concat([
                .just(.setTimePickerViewHidden(!selectedType.shouldSetTime)),
                .just(.setTimerNamePlaceholder(selectedType.placeholder)),
                .just(.setTimer(timer))
            ])
            
        case .ringtoneButtonDidTap:
            return showRingtoneSelectScene(selectedRingtoneRelay: selectedRingtoneRelay)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setTimePickerViewHidden(let isHidden):
            newState.isTimePickerViewHidden = isHidden
            
        case .setTimer(let timer):
            newState.timer = timer
            let isCompleteButtonEnabled = validateCompleteButtonIsEnable(for: timer)
            newState.isCompleteButtonEnabled = isCompleteButtonEnabled
            
        case .setTimerNamePlaceholder(let placeholder):
            newState.timerNamePlaceholder = placeholder
            
        case .updateSelectedRingtone(let ringtone):
            newState.selectedRingtone = ringtone
            newState.timer.ringtone = ringtone
        }
        return newState
    }
}

// MARK: - Supporting Methods

private extension TimerCreateReactor {
    func validateCompleteButtonIsEnable(for timer: Timer) -> Bool {
        let isTypeCountUp = timer.type == .countUp
        let isTotalSecondsBiggerThanZero = timer.totalSeconds > .zero
        let isCompleteButtonEnable = isTypeCountUp ? true : isTotalSecondsBiggerThanZero
        return isCompleteButtonEnable
    }
}

// MARK: - Side Effect Methods

private extension TimerCreateReactor {
    func exitScene() -> Observable<Mutation> {
        coordinator?.coordinate(by: .finishTimerCreateScene)
        return .empty()
    }
    
    func showRingtoneSelectScene(selectedRingtoneRelay: BehaviorRelay<Ringtone>) -> Observable<Mutation> {
        coordinator?.coordinate(by: .showRingtoneSelectScene(selectedRingtoneRelay: selectedRingtoneRelay))
        return selectedRingtoneRelay.map { Mutation.updateSelectedRingtone($0) }
    }
    
    func acceptCreatedTimerRelay(createdTimer: Timer) -> Observable<Mutation> {
        createdTimerRelay.accept(createdTimer)
        return .empty()
    }
}
