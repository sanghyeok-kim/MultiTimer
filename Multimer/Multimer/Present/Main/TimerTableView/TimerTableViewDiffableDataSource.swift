//
//  TimerTableViewDiffableDataSource.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/13.
//

import RxSwift
import RxRelay

final class TimerTableViewDiffableDataSource: UITableViewDiffableDataSource<TableViewSection, TimerCellViewModel> {
    
    let cellDidMove = PublishRelay<(source: IndexPath, destination: IndexPath)>()
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<TableViewSection, TimerCellViewModel>
    
    private let cellProvider = { (tableView: UITableView,
                                  indexPath: IndexPath,
                                  cellViewModel: TimerCellViewModel) -> UITableViewCell in
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TimerViewCell.identifier,
            for: indexPath
        ) as? TimerViewCell else { return UITableViewCell() }
        cell.bind(viewModel: cellViewModel)
        return cell
    }
    
    init(tableView: UITableView) {
        super.init(tableView: tableView, cellProvider: cellProvider)
    }
    
    // MARK: - DiffableDataSource Methods
    
    func update(with cellViewModels: [TimerCellViewModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(cellViewModels)
        apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - UITableViewDataSource Methods
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        cellDidMove.accept((sourceIndexPath, destinationIndexPath))
    }
}
