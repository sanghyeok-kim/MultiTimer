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
        let cellDidSwipe: Observable<Int>
//        let cellDidMove: Observable<(from: Int, to: Int)>
    }
    
    struct Output {
        let timerCellViewModels = BehaviorRelay<[TimerCellViewModel]>(value: [])
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // FIXME: 영구저장소에서 불러오기
        let timerCellViewModels = Timer.generateMock().map { timer in
            TimerCellViewModel(timer: timer)
        }
        output.timerCellViewModels.accept(timerCellViewModels)
        
        input.cellDidSwipe // TODO: Simplify or RxDataSource 도입 고려
            .withLatestFrom(output.timerCellViewModels) { index, viewModels in
                viewModels.filter { $0 !== viewModels[index] }
            }
            .bind(to: output.timerCellViewModels)
            .disposed(by: disposeBag)
        
        return output
    }
}
