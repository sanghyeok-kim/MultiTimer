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
        let viewDidLoad: Observable<Void>
        let cellDidSwipe: Observable<Int>
//        let cellDidMove: Observable<(from: Int, to: Int)>
        let addTimerButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let timerCellViewModels = BehaviorRelay<[TimerCellViewModel]>(value: [])
        let pushTimerSettingViewModel = PublishRelay<TimerSettingViewModel>()
        let presentTimerSettingViewModel = PublishRelay<TimerSettingViewModel>()
    }
    
    private let mainUseCase: MainUseCase
//    private let output: Output
    
    init(mainUseCase: MainUseCase) {
//        self.timers = fetchUserTimers()
//
//        let timerCellViewModels = Timer.generateMock().map { timer in
//            TimerCellViewModel(timer: timer)
//        }
        self.mainUseCase = mainUseCase
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        let userTimers = input.viewDidLoad
            .withUnretained(self)
            .map { `self`, _ in
                self.mainUseCase.fetchUserTimers()
            }
            .share()
        
        // TimerCellViewModels 구성
        let cellViewModels = userTimers
            .map { timers -> [TimerCellViewModel] in
                return timers.map { TimerCellViewModel(timer: $0) }
            }
            .share()
        
        cellViewModels
            .bind(to: output.timerCellViewModels) // FIXME: VC에게 전달하지말고 Coordinator에게 전달
            .disposed(by: disposeBag)
        
        
        // 탭한 cell의 TimerSettingViewModel을 생성해서 push 하는 로직
        cellViewModels
            .flatMapLatest { cellViewModels -> Observable<TimerSettingViewModel> in
                // 모든 cellViewModel의 ouput.timerSettingViewModel 이벤트를 하나의 스트림으로 bind
                let timerSettingViewModel = cellViewModels.map { $0.output.timerSettingViewModel.asObservable() }
                return .merge(timerSettingViewModel)
            }
            .bind(to: output.pushTimerSettingViewModel)
            .disposed(by: disposeBag)
        
        
        // 새로운 TimerSettingViewModel 추가 로직
        let newTimerSettingViewModel = input.addTimerButtonDidTap
            .map { TimerSettingViewModel(timer: Timer(time: Time())) }
            .share()
        
        newTimerSettingViewModel
            .bind(to: output.presentTimerSettingViewModel)
            .disposed(by: disposeBag)
        
        newTimerSettingViewModel
            .flatMap { $0.output.newTimer }
            .map { TimerCellViewModel(timer: $0) }
            .withLatestFrom(output.timerCellViewModels) { newTimerCellViewModel, currentCellViewModels in
                var currentCellViewModels = currentCellViewModels
                currentCellViewModels.append(newTimerCellViewModel)
                return currentCellViewModels
            }
            .bind(to: output.timerCellViewModels)
            .disposed(by: disposeBag)
        
        
        // Cell Swipe-to-delete 이벤트 처리 로직
        input.cellDidSwipe
            .withLatestFrom(output.timerCellViewModels) { index, viewModels in
                viewModels.filter { $0 !== viewModels[index] }
            }
            .bind(to: output.timerCellViewModels)
            .disposed(by: disposeBag)
        
        return output
    }
}
