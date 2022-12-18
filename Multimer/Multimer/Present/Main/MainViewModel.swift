//
//  MainViewModel.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/04.
//

import RxSwift
import RxRelay

final class MainViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad = PublishRelay<Void>()
        let filteringSegmentControlDidTap = PublishRelay<TimerFilteringCondition>()
        let cellDidSwipeFromLeading = PublishRelay<Int>()
        let cellDidSwipeFromTrailing = PublishRelay<Int>()
        let cellDidMove = PublishRelay<(source: IndexPath, destination: IndexPath)>()
        let timerAddButtonDidTap = PublishRelay<Void>()
        let timerEditButtonDidTap = PublishRelay<Void>()
        let selectedRows = PublishRelay<[Int]>()
        let editButtonDidTap = PublishRelay<Bool>()
        let timerControlButtonInEditViewDidTap = PublishRelay<EditViewButtonType>()
        let deleteButtonInEditViewDidTap = PublishRelay<Void>()
        let confirmDeleteButtonDidTap = PublishRelay<Void>()
    }
    
    struct Output {
        let filteredTimerCellViewModels = BehaviorRelay<[TimerCellViewModel]>(value: [])
        let pushTimerSettingViewModel = PublishRelay<TimerSettingViewModel>()
        let presentTimerSettingViewModel = PublishRelay<TimerSettingViewModel>()
        let maintainEditingMode = PublishRelay<Bool>()
        let enableEditViewButtons = PublishRelay<Bool>()
        let showDeleteConfirmAlert = PublishRelay<Int>()
    }
    
    private let fetchedTimerCellViewModels = BehaviorRelay<[TimerCellViewModel]>(value: [])
    
    let input = Input()
    let output = Output()
    
    private let disposeBag = DisposeBag()
    private let mainUseCase: MainUseCase
    
    init(mainUseCase: MainUseCase) {
        self.mainUseCase = mainUseCase
        
        // MARK: - Handle Event from Input
        
        handleViewDidLoad()
        handleFilteringSegmentDidTapOrFetchedTimerCellViewModels()
        handleCellDidSwipeFromLeading()
        handleCellDidSwipeFromTrailing()
        handleCellDidMove()
        handleAddTimerButtonDidTap()
        handleEditButtonDidTap()
        handleEventFromEditView(with: mainUseCase)
        
        // MARK: - Handle Event from UseCase
        
        handleFetchedUserTimer()
//        handleUseCaseError()
        
        // MARK: - Handle Event from FetchedTimerCellViewModels
        
        handleEventFromFetchedTimerCellViewModels()
    }
}

// MARK: - Event Handling Methods

private extension MainViewModel {
    func handleViewDidLoad() {
        input.viewDidLoad
            .bind(onNext: mainUseCase.fetchUserTimers)
            .disposed(by: disposeBag)
    }
    
    func handleFilteringSegmentDidTapOrFetchedTimerCellViewModels() {
        Observable.combineLatest(input.filteringSegmentControlDidTap, fetchedTimerCellViewModels)
            .map { (condition, fetchedViewModels) -> [TimerCellViewModel] in
                switch condition {
                case .all:
                    return fetchedViewModels
                case .active:
                    return fetchedViewModels.filter { $0.output.isActive.value }
                }
            }
            .bind(to: output.filteredTimerCellViewModels)
            .disposed(by: disposeBag)
    }
    
    func handleCellDidSwipeFromLeading() {
        input.cellDidSwipeFromLeading
            .withLatestFrom(output.filteredTimerCellViewModels) { index, viewModels in
                viewModels[index]
            }
            .bind {
                $0.input.resetButtonDidTap.accept(())
            }
            .disposed(by: disposeBag)
    }
    
    func handleCellDidSwipeFromTrailing() {
        let cellViewModelToDelete = input.cellDidSwipeFromTrailing
            .withLatestFrom(output.filteredTimerCellViewModels) { index, viewModels -> TimerCellViewModel in
                return viewModels[index]
            }
            .share()
        
        cellViewModelToDelete
            .do { $0.removeNotification() }
            .map { $0.identifier }
            .bind(onNext: mainUseCase.deleteTimer)
            .disposed(by: disposeBag)
        
        cellViewModelToDelete
            .withLatestFrom(fetchedTimerCellViewModels) { cellViewModelToDelete, viewModels in
                viewModels.filter { $0.identifier != cellViewModelToDelete.identifier }
            }
            .bind(to: fetchedTimerCellViewModels)
            .disposed(by: disposeBag)
    }
    
    func handleCellDidMove() {
        input.cellDidMove
            .filter { $0.source != $0.destination }
            .withUnretained(self) { `self`, indexPath -> [TimerCellViewModel] in
                let movedTimerCellViewModels = self.moveTimerCellViewModel(from: indexPath.source, to: indexPath.destination)
                return movedTimerCellViewModels
            }
            .bind(to: fetchedTimerCellViewModels)
            .disposed(by: disposeBag)
    }
    
    func handleAddTimerButtonDidTap() {
        let newTimerSettingViewModel = input.timerAddButtonDidTap
            .map { TimerSettingViewModel(timer: Timer(time: TimeFactory.createDefaultTime())) }
            .share()
        
        newTimerSettingViewModel
            .bind(to: output.presentTimerSettingViewModel)
            .disposed(by: disposeBag)
        
        let createdTimer = newTimerSettingViewModel
            .flatMapLatest { $0.output.newTimer }
            .share()
        
        createdTimer
            .map {
                TimerCellViewModel(
                    identifier: $0.identifier,
                    timerUseCase: TimerUseCase(timer: $0, timerPersistentRepository: CoreDataTimerRepository(maximumStorageCount: 20))
                )
            }
            .withLatestFrom(fetchedTimerCellViewModels) { newTimerCellViewModel, currentCellViewModels in
                var currentCellViewModels = currentCellViewModels
                currentCellViewModels.append(newTimerCellViewModel)
                return currentCellViewModels
            }
            .bind(to: fetchedTimerCellViewModels)
            .disposed(by: disposeBag)
        
        createdTimer
            .bind(onNext: mainUseCase.appendTimer)
            .disposed(by: disposeBag)
    }
    
    func handleFetchedUserTimer() {
        mainUseCase.fetchedUserTimers
            .map {
                $0.map {
                    TimerCellViewModel(
                        identifier: $0.identifier,
                        timerUseCase: TimerUseCase(timer: $0, timerPersistentRepository: CoreDataTimerRepository(maximumStorageCount: 20))
                    )
                }
            }
            .bind(to: fetchedTimerCellViewModels) // FIXME: VC에게 전달하지말고 Coordinator에게 전달
            .disposed(by: disposeBag)
    }
    
    func handleEventFromFetchedTimerCellViewModels() {
        fetchedTimerCellViewModels // cellVM의 isActive 상태가 변경될 시, 현재 filtering 조건에 따라 화면에 나타나는 cell을 갱신
            .flatMapLatest { Observable<Bool>.merge($0.map { $0.output.isActive.skip(1).asObservable() }) }
            .delay(DispatchTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
            .withLatestFrom(fetchedTimerCellViewModels)
            .bind(to: fetchedTimerCellViewModels)
            .disposed(by: disposeBag)
        
        fetchedTimerCellViewModels
            .flatMapLatest { cellViewModels -> Observable<TimerSettingViewModel> in
                let timerSettingViewModel = cellViewModels.map { $0.output.timerSettingViewModel.asObservable() }
                return .merge(timerSettingViewModel)
            }
            .bind(to: output.pushTimerSettingViewModel)
            .disposed(by: disposeBag)
    }
    
    func handleEditButtonDidTap() {
        input.editButtonDidTap
            .withLatestFrom(output.filteredTimerCellViewModels) { isEditing, viewModels -> Bool in
                let canCellTap = !isEditing
                viewModels.forEach { $0.enableCellTapButton(by: canCellTap) }
                return isEditing
            }
            .bind(to: output.maintainEditingMode)
            .disposed(by: disposeBag)
        
        input.editButtonDidTap
            .filter { !$0 }
            .map { _ in [] }
            .bind(to: input.selectedRows)
            .disposed(by: disposeBag)
    }
    
    func handleEventFromEditView(with mainUseCase: MainUseCase) {
        let selectedTimerCellViewModels = input.selectedRows
            .withLatestFrom(output.filteredTimerCellViewModels) { ($0, $1) }
            .map { (selectedRows, filteredCellViewModels) in
                selectedRows.map { filteredCellViewModels[$0] }
            }
            .share()
        
        selectedTimerCellViewModels
            .map { !$0.isEmpty }
            .bind(to: output.enableEditViewButtons)
            .disposed(by: disposeBag)
        
        input.timerControlButtonInEditViewDidTap
            .withLatestFrom(selectedTimerCellViewModels) { ($0, $1) }
            .bind { (buttonType, selectedTimerCellViewModels) in
                selectedTimerCellViewModels.forEach { $0.controlTimerIfSelected(by: buttonType) }
            }
            .disposed(by: disposeBag)
        
        input.timerControlButtonInEditViewDidTap
            .withLatestFrom(output.filteredTimerCellViewModels) { buttonType, viewModels in
                viewModels.forEach { $0.enableCellTapButton(by: true) }
            }
            .map { _ in false }
            .bind(to: output.maintainEditingMode)
            .disposed(by: disposeBag)
        
        input.deleteButtonInEditViewDidTap
            .withLatestFrom(input.selectedRows)
            .map { $0.count }
            .bind(to: output.showDeleteConfirmAlert)
            .disposed(by: disposeBag)
        
        let cellViewModelsToDelete = input.confirmDeleteButtonDidTap
            .withLatestFrom(selectedTimerCellViewModels)
            .share()
        
        cellViewModelsToDelete
            .withLatestFrom(fetchedTimerCellViewModels) { cellViewModelsToDelete, fetchedTimerCellViewModels in
                fetchedTimerCellViewModels.filter { !cellViewModelsToDelete.contains($0) }
            }
            .bind(to: fetchedTimerCellViewModels)
            .disposed(by: disposeBag)
        
        cellViewModelsToDelete
            .bind {
                $0.forEach { deleteTarget in
                    deleteTarget.removeNotification()
                    mainUseCase.deleteTimer(by: deleteTarget.identifier)
                }
            }
            .disposed(by: disposeBag)
        
        input.confirmDeleteButtonDidTap
            .map { _ in [] }
            .bind(to: input.selectedRows)
            .disposed(by: disposeBag)
    }
}

// MARK: - Helper Methods

private extension MainViewModel {
    func moveTimerCellViewModel(from source: IndexPath, to destination: IndexPath) -> [TimerCellViewModel] {
        let currentTimerCellViewModels = output.filteredTimerCellViewModels.value
        let fetchedTimerCellViewModels = fetchedTimerCellViewModels.value
        
        let sourceViewModel = currentTimerCellViewModels[source.row]
        let destinationViewModel = currentTimerCellViewModels[destination.row]
        
        let destIndex = fetchedTimerCellViewModels.firstIndex(of: destinationViewModel) ?? 0
        var newCellViewModels = fetchedTimerCellViewModels.filter { $0 != sourceViewModel }
        newCellViewModels.insert(sourceViewModel, at: destIndex)
        
        return newCellViewModels
    }
}
