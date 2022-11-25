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
        let viewDidLoad = PublishRelay<Void>()
        let cellDidSwipe = PublishRelay<Int>()
        let filteringSegmentDidTap = PublishRelay<TimerFilteringCondition>()
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
//        self.timers = fetchUserTimers()
//
//        let timerCellViewModels = Timer.generateMock().map { timer in
//            TimerCellViewModel(timer: timer)
//        }
        self.mainUseCase = mainUseCase
        
        // MARK: - Event Handling from Input
        
        let userTimers = input.viewDidLoad
            .withUnretained(self)
            .map { `self`, _ in // FIXME: flatMapLatest 비동기 fetch로 변경
                self.mainUseCase.fetchUserTimers()
            }
            .share()
        handleFilteringSegmentDidTapOrFetchedTimerCellViewModels()
        
        userTimers
            .map { timers -> [TimerCellViewModel] in
                return timers.map { TimerCellViewModel(timerUseCase: TimerUseCase(timer: $0)) }
            }
            .bind(to: output.timerCellViewModels) // FIXME: VC에게 전달하지말고 Coordinator에게 전달
            .disposed(by: disposeBag)
        
        // MARK: - Bind TimerSettingViewModel from TimerCellViewModel Output
        
        output.timerCellViewModels
            .flatMapLatest { cellViewModels -> Observable<TimerSettingViewModel> in
                let timerSettingViewModel = cellViewModels.map { $0.output.timerSettingViewModel.asObservable() }
                return .merge(timerSettingViewModel)
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
        
        // MARK: - Handle AddTimerButtonDidTap from Input
        
        let newTimerSettingViewModel = input.addTimerButtonDidTap
            .map { TimerSettingViewModel(timer: Timer(time: Time())) }
            .share()
        
        newTimerSettingViewModel
            .bind(to: output.presentTimerSettingViewModel)
            .disposed(by: disposeBag)
        
        newTimerSettingViewModel
            .flatMap { $0.output.newTimer }
            .map { TimerCellViewModel(timerUseCase: TimerUseCase(timer: $0)) }
            .withLatestFrom(output.timerCellViewModels) { newTimerCellViewModel, currentCellViewModels in
                var currentCellViewModels = currentCellViewModels
                currentCellViewModels.append(newTimerCellViewModel)
                return currentCellViewModels
            }
            .bind(to: output.timerCellViewModels)
    func handleFetchedUserTimer() {
        mainUseCase.fetchUserTimers()
            .map { $0.map { TimerCellViewModel(timerUseCase: TimerUseCase(timer: $0)) } }
            .bind(to: fetchedTimerCellViewModels) // FIXME: VC에게 전달하지말고 Coordinator에게 전달
            .disposed(by: disposeBag)
    }
            .disposed(by: disposeBag)
        
        // MARK: - Handle CellDidSwipe from Input
        
        input.cellDidSwipe
            .withLatestFrom(output.timerCellViewModels) { index, viewModels in
                viewModels.filter { $0 !== viewModels[index] }
            }
            .bind(to: output.timerCellViewModels)
            .disposed(by: disposeBag)
    }
}
