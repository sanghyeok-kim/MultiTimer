//
//  TimerTableViewDiffableDataSource+Rx+update.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/14.
//

import RxSwift

extension Reactive where Base: TimerTableViewDiffableDataSource {
    var cellViewModels: Binder<[TimerCellViewModel]> {
        return Binder(base) { dataSource, timerCellViewModels in
            dataSource.update(with: timerCellViewModels)
        }
    }
}
