//
//  DefaultHomeCoordinator.swift
//  Multimer
//
//  Created by 김상혁 on 2023/07/28.
//

import RxRelay

final class DefaultHomeCoordinator: HomeCoordinator {
    
    var childCoordinatorMap: [CoordinatorType: Coordinator] = [:]
    var navigationController: UINavigationController
    let type: CoordinatorType = .home
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        coordinate(by: .appDidStart)
    }
    
    func coordinate(by coordinateAction: HomeCoordinatorAction) {
        switch coordinateAction {
        case .appDidStart:
            pushHomeViewController()
        case .showTimerCreateScene(let createdTimerRelay):
            presentTimerCreateViewController(createdTimerRelay: createdTimerRelay)
        case .showTimerEditScene(let initialTimer, let editedTimerRelay):
            pushTimerEditViewController(initialTimer: initialTimer, editedTimerRelay: editedTimerRelay)
        case .finishTimerCreateScene:
            navigationController.dismiss(animated: true)
        case .finishTimerEditScene:
            navigationController.popViewController(animated: true)
        }
    }
}

// MARK: - Coordinating Methods

private extension DefaultHomeCoordinator {
    func pushHomeViewController() {
        let homeViewController = HomeViewController()
        let homeViewReactor = HomeViewModel(
            coordinator: self,
            homeUseCase: DefaultHomeUseCase(
                timerPersistentRepository: CoreDataTimerRepository()
            )
        )
        homeViewController.bind(viewModel: homeViewReactor)
        navigationController.pushViewController(homeViewController, animated: false)
    }
    
    func presentTimerCreateViewController(createdTimerRelay: PublishRelay<Timer>) {
        let timerCreateViewController = TimerCreateViewController()
        let timerCreateReactor = TimerCreateReactor(
            coordinator: self,
            createdTimerRelay: createdTimerRelay
        )
        timerCreateViewController.reactor = timerCreateReactor
        navigationController.present(timerCreateViewController, animated: true)
    }
    
    func pushTimerEditViewController(initialTimer: Timer, editedTimerRelay: PublishRelay<Timer>) {
        let timerEditingViewController = TimerEditingViewController()
        let timerEditingReactor = TimerEditingReactor(
            initialTimer: initialTimer,
            coordinator: self,
            editedTimerRelay: editedTimerRelay
        )
        timerEditingViewController.reactor = timerEditingReactor
        navigationController.pushViewController(timerEditingViewController, animated: true)
    }
}
