//
//  TimerTableViewDelegate.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import RxSwift
import RxRelay

final class TimerTableViewDelegate: NSObject, UITableViewDelegate {
    
    let cellDidSwipe = PublishRelay<Int>()
//    let cellDidMove = PublishRelay<(from: Int, to: Int)>() // TODO: cell 드래그-드롭 이동 구현
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completion) in
            self?.cellDidSwipe.accept(indexPath.row)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        // TODO: 타이머 초기화 구현
        let resetAction = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completion) in
//            self?.creditCardList.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        resetAction.image = UIImage(systemName: "stop.circle")
        resetAction.backgroundColor = .systemBlue
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, resetAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimerViewCell.identifier,for: indexPath) as? TimerViewCell
        cell?.viewModel = nil
    }
}
