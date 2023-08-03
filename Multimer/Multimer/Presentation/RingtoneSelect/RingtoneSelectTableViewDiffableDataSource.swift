//
//  RingtoneSelectTableViewDiffableDataSource.swift
//  Multimer
//
//  Created by 김상혁 on 2023/08/02.
//

import UIKit

final class RingtoneSelectTableViewDiffableDataSource: UITableViewDiffableDataSource<RingtoneType, RingtoneCellModel> {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<RingtoneType, RingtoneCellModel>

    init(tableView: UITableView) {
        super.init(tableView: tableView) { (tableView, indexPath, cellViewModel) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: RingtoneViewCell.identifier,
                for: indexPath
            ) as? RingtoneViewCell
            let ringtoneName = LocalizableString.ringtoneName(ringtone: cellViewModel.ringtone).localized
            cell?.configure(title: ringtoneName, isSelected: cellViewModel.isSelected)
            return cell
        }
    }
    
    // MARK: - DiffableDataSource Methods
    
    func applySnapshot(for ringtoneCellModelMap: [RingtoneType: [RingtoneCellModel]]) {
        var snapshot = Snapshot()
        snapshot.appendSections(RingtoneType.allCases)
        for type in RingtoneType.allCases {
            if let cellModels = ringtoneCellModelMap[type] {
                snapshot.appendItems(cellModels, toSection: type)
            }
        }
        apply(snapshot, animatingDifferences: false)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return RingtoneType.allCases[section].title
    }
}
