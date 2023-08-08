//
//  RingtoneSelectReactor.swift
//  Multimer
//
//  Created by 김상혁 on 2023/07/31.
//

import RxRelay
import ReactorKit

final class RingtoneSelectReactor: Reactor {
    
    enum Action {
        case viewDidLoad
        case ringtoneDidSelect(IndexPath)
        case closeButtonDidTap
    }
    
    enum Mutation {
        case selectRingtone(Ringtone)
        case playRingtoneSound(Ringtone)
    }
    
    struct State {
        var ringtoneCellModelMap: [RingtoneType: [RingtoneCellModel]] = [:]
        var ringtoneToPlay: Ringtone?
    }
    
    var initialState = State()
    private weak var coordinator: HomeCoordinator?
    private let selectedRingtoneRelay: BehaviorRelay<Ringtone>
    
    init(coordinator: HomeCoordinator?, selectedRingtoneRelay: BehaviorRelay<Ringtone>) {
        self.coordinator = coordinator
        self.selectedRingtoneRelay = selectedRingtoneRelay
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let selectedRingtone = selectedRingtoneRelay.value
            return .just(.selectRingtone(selectedRingtone))
            
        case .ringtoneDidSelect(let indexPath):
            let ringtoneType = RingtoneType.allCases[indexPath.section]
            guard let ringtoneCellModels = currentState.ringtoneCellModelMap[ringtoneType] else {
                return .empty()
            }
            let selectedRingtone = ringtoneCellModels[indexPath.row].ringtone
            return .concat(
                .just(.playRingtoneSound(selectedRingtone)),
                .just(.selectRingtone(selectedRingtone)),
                acceptSelectedRingtone(selectedRingtone)
            )
            
        case .closeButtonDidTap:
            return finishScene()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .selectRingtone(let selectedRingtone):
            newState.ringtoneCellModelMap = generateRingtoneCellModelMap(selectedRingtone: selectedRingtone)
        case .playRingtoneSound(let ringtoneToPlay):
            newState.ringtoneToPlay = ringtoneToPlay
        }
        return newState
    }
}

// MARK: - Side Effect Methods

private extension RingtoneSelectReactor {
    func acceptSelectedRingtone(_ ringtone: Ringtone) -> Observable<Mutation> {
        selectedRingtoneRelay.accept(ringtone)
        return .empty()
    }
    
    func finishScene() -> Observable<Mutation> {
        coordinator?.coordinate(by: .finishRingtoneSelectScene)
        return .empty()
    }
}

// MARK: - Supporting Methods

private extension RingtoneSelectReactor {
    func generateRingtoneCellModelMap(selectedRingtone: Ringtone) -> [RingtoneType: [RingtoneCellModel]] {
        let ringtoneCellModels = Ringtone.allCases.map {
            RingtoneCellModel(isSelected: $0 == selectedRingtone, ringtone: $0)
        }
        let ringtoneCellModelMap = Dictionary(grouping: ringtoneCellModels) { $0.ringtone.type }
        return ringtoneCellModelMap
    }
}
