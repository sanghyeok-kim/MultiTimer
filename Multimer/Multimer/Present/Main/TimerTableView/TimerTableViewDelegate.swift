//
//  TimerTableViewDelegate.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import RxSwift
import RxRelay

final class TimerTableViewDelegate: NSObject, UITableViewDelegate {
    
    let cellDidSwipeFromTrailing = PublishRelay<Int>()
    let cellDidSwipeFromLeading = PublishRelay<Int>()
    let selectedRows = PublishRelay<[Int]>()
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completion) in
            self?.cellDidSwipeFromTrailing.accept(indexPath.row)
        }
        deleteAction.image = UIImage(systemName: "trash")

        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let resetAction = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completion) in
            self?.cellDidSwipeFromLeading.accept(indexPath.row)
            completion(true)
        }
        resetAction.image = UIImage(systemName: "stop.circle")
        resetAction.backgroundColor = .systemBlue
        
        let config = UISwipeActionsConfiguration(actions: [resetAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRows.accept(tableView.indexPathsForSelectedRows?.compactMap { $0.row } ?? [])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedRows.accept(tableView.indexPathsForSelectedRows?.compactMap { $0.row } ?? [])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TimerTableFooterView.identifier
        ) as? TimerTableFooterView else { return UIView() }
        
        // TODO: FooterViewModel 적용
        
        return footerView
    }
}
