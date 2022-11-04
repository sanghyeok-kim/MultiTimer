//
//  MainViewModel.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/04.
//

import RxSwift
import RxRelay

final class MainViewModel: ViewModelType {
    
    private let disposBag = DisposeBag()
    
    struct Input {
        let cellDidSwipe: Observable<Int>
//        let cellDidMove: Observable<(from: Int, to: Int)>
    }
    
    struct Output {
        var timerCellViewModels = BehaviorRelay<[TimerCellViewModel]>(value: [])
    }
    
    func transform(from input: Input) -> Output {
        let output = Output()
        
        // FIXME: 영구저장소에서 불러오기
        let timerCellViewModels = Timer.generateMock().map { timer in
            TimerCellViewModel(timer: timer)
        }
        output.timerCellViewModels.accept(timerCellViewModels)
        
        return output
    }
}
