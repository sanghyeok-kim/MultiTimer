//
//  MainViewModel.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/04.
//

import RxSwift
import RxRelay

final class MainRepository {
    func fetchUserTimers_() -> Observable<[Timer]> { // FIXME: 영구저장소에서 불러오기
        return Observable.just(Timer.generateMock()) //왜 just로 보내면 2번 보내질까??????????????????
    }
    
    func fetchUserTimers() -> [Timer] {
        return Timer.generateMock()
    }
}

final class MainUseCase {
    let mainRepository: MainRepository
    
    init(mainRepository: MainRepository) {
        self.mainRepository = mainRepository
    }
    
    func fetchUserTimers_() -> Observable<[Timer]> { // -> Observable<[Timer]> ?
        return mainRepository.fetchUserTimers_()
    }
    
    func fetchUserTimers() -> [Timer] {
        return mainRepository.fetchUserTimers()
    }
}

final class MainViewModel: ViewModelType {
    
    struct Input {
        let filteringSegmentDidTap = PublishRelay<TimerFilteringCondition>()
        let cellDidSwipeFromLeading = PublishRelay<Int>()
        let cellDidSwipeFromTrailing = PublishRelay<Int>()
//        let cellDidMove = PublishRelay<(from: Int, to: Int)>()
        let addTimerButtonDidTap = PublishRelay<Void>()
    }
    
    struct Output {
        let filteredTimerCellViewModels = BehaviorRelay<[TimerCellViewModel]>(value: [])
        let pushTimerSettingViewModel = PublishRelay<TimerSettingViewModel>()
        let presentTimerSettingViewModel = PublishRelay<TimerSettingViewModel>()
    }
    
    private let fetchedTimerCellViewModels = BehaviorRelay<[TimerCellViewModel]>(value: [])
    
    let input = Input()
    let output = Output()
    
    private let disposeBag = DisposeBag()
    private let mainUseCase: MainUseCase
    
    init(mainUseCase: MainUseCase) {
        self.mainUseCase = mainUseCase
        
        // MARK: - Event Handling from Input
        
        handleFilteringSegmentDidTapOrFetchedTimerCellViewModels()
        handleCellDidSwipeFromLeading()
        handleCellDidSwipeFromTrailing()
        handleAddTimerButtonDidTap()
        
        // MARK: - Event Handling from UseCase
        
        handleFetchedUserTimer()
        
        // MARK: - Event Handling from FetchedTimerCellViewModels
        
        handleEventFromFetchedTimerCellViewModels()
    }
}

// MARK: - Event Handling Function

private extension MainViewModel {
    func handleFilteringSegmentDidTapOrFetchedTimerCellViewModels() {
        Observable.combineLatest(input.filteringSegmentDidTap, fetchedTimerCellViewModels)
            .map { (condition, fetchedViewModels) -> [TimerCellViewModel] in
                switch condition {
                case .all: return fetchedViewModels
                case .active: return fetchedViewModels.filter { $0.output.isActive.value }
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
                let cellViewModelToDelete = viewModels[index]
                cellViewModelToDelete.timerUseCase.removeNotification()
                return cellViewModelToDelete
            }
            .share()
        
        cellViewModelToDelete
            .withLatestFrom(fetchedTimerCellViewModels) { cellViewModelToDelete, viewModels in
                viewModels.filter { $0.identifier != cellViewModelToDelete.identifier }
            }
            .bind(to: fetchedTimerCellViewModels)
            .disposed(by: disposeBag)
    }
    
    func handleAddTimerButtonDidTap() {
        let newTimerSettingViewModel = input.addTimerButtonDidTap
            .map { TimerSettingViewModel(timer: Timer(time: Time())) }
            .share()
        
        newTimerSettingViewModel
            .bind(to: output.presentTimerSettingViewModel)
            .disposed(by: disposeBag)
        
        newTimerSettingViewModel
            .flatMapLatest { $0.output.newTimer }
            .map { TimerCellViewModel(timerUseCase: TimerUseCase(timer: $0)) }
            .withLatestFrom(fetchedTimerCellViewModels) { newTimerCellViewModel, currentCellViewModels in
                var currentCellViewModels = currentCellViewModels
                currentCellViewModels.append(newTimerCellViewModel)
                return currentCellViewModels
            }
            .bind(to: fetchedTimerCellViewModels)
            .disposed(by: disposeBag)
    }
    
    func handleFetchedUserTimer() {
        mainUseCase.fetchUserTimers()
            .map { $0.map { TimerCellViewModel(timerUseCase: TimerUseCase(timer: $0)) } }
            .bind(to: fetchedTimerCellViewModels) // FIXME: VC에게 전달하지말고 Coordinator에게 전달
            .disposed(by: disposeBag)
    }
    
    func handleEventFromFetchedTimerCellViewModels() {
        fetchedTimerCellViewModels
            .flatMapLatest { Observable<Bool>.merge($0.map { $0.output.isActive.skip(1).asObservable() }) }
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
}
