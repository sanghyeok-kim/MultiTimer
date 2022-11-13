//
//  TimerTableViewDiffableDataSource.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/13.
//

import UIKit

final class TimerTableViewDiffableDataSource { // TODO: 추상화 고려해보기
    typealias DataSource = UITableViewDiffableDataSource<TableViewSection, TimerCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<TableViewSection, TimerCellViewModel>
    
    private let dataSource: DataSource
    
    private let cellProvider = { (tableView: UITableView,
                                  indexPath: IndexPath,
                                  cellViewModel: TimerCellViewModel) -> UITableViewCell in
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TimerViewCell.identifier,
            for: indexPath
        ) as? TimerViewCell else { return UITableViewCell() }
        cell.viewModel = cellViewModel
        return cell
    }
    
    init(tableView: UITableView) {
        dataSource = DataSource(tableView: tableView, cellProvider: cellProvider)
    }
    
    func update(with cellViewModels: [TimerCellViewModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(cellViewModels)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
