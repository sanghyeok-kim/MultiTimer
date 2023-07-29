//
//  HomeCoordinatorAction.swift
//  Multimer
//
//  Created by 김상혁 on 2023/07/28.
//

import RxRelay

enum HomeCoordinatorAction {
    case appDidStart
    case showTimerCreateScene(createdTimerRelay: PublishRelay<Timer>)
    case showTimerEditScene(initialTimer: Timer, editedTimerRelay: PublishRelay<Timer>)
    case finishTimerCreateScene
    case finishTimerEditScene
}
