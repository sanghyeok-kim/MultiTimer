//
//  TimerTableViewDataSource.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import UIKit

final class TimerTableViewDataSource: NSObject, UITableViewDataSource {
    
    var timers = [Timer(id: UUID(), name: "알림1", tag: "태그1", time: "10:20"),
                  Timer(id: UUID(), name: "알림2", tag: "태그2", time: "01:50"),
                  Timer(id: UUID(), name: "알림3", tag: "태그3", time: "11:40:20")]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TimerViewCell.identifier,
            for: indexPath
        ) as? TimerViewCell else { return UITableViewCell() }
        
        let timer = timers[indexPath.row]
        cell.set(title: timer.name, tag: timer.tag, time: timer.time)
        return cell
    }
    
    func swapByLongPress(with sender: UILongPressGestureRecognizer, to tableView: UITableView) {
        let longPressedPoint = sender.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: longPressedPoint) else { return }
        
        struct BeforeIndexPath {
            static var value: IndexPath?
        }
        
        struct CellSnapshotView {
            static var value: UIView?
        }
        
        switch sender.state {
        case .began:
            BeforeIndexPath.value = indexPath
            
            // snapshot을 tableView에 추가
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            CellSnapshotView.value = cell.snapshotCellStyle()
            CellSnapshotView.value?.center = cell.center
            CellSnapshotView.value?.alpha = 0.0
            if let cellSnapshotView = CellSnapshotView.value {
                tableView.addSubview(cellSnapshotView)
            }
            
            // 원래의 cell을 hidden시키고 snapshot이 보이도록 설정
            UIView.animate(withDuration: 0.3) {
                CellSnapshotView.value?.center = longPressedPoint
                CellSnapshotView.value?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                CellSnapshotView.value?.alpha = 0.8
                cell.alpha = 0.0
            } completion: { (isFinish) in
                if isFinish {
                    cell.isHidden = true
                }
            }
            
        case .changed:
            CellSnapshotView.value?.center = longPressedPoint
            
            if let beforeIndexPath = BeforeIndexPath.value, beforeIndexPath != indexPath {
                let beforeValue = timers[beforeIndexPath.row]
                let afterValue = timers[indexPath.row]
                timers[beforeIndexPath.row] = afterValue
                timers[indexPath.row] = beforeValue
                tableView.moveRow(at: beforeIndexPath, to: indexPath)
                
                BeforeIndexPath.value = indexPath
            }
        default:
            // 손가락을 떼면 indexPath에 셀이 나타나는 애니메이션
            guard let beforeIndexPath = BeforeIndexPath.value,
                  let cell = tableView.cellForRow(at: beforeIndexPath) else { return }
            cell.isHidden = false
            cell.alpha = 0.0
            
            // Snapshot이 사라지고 셀이 나타내는 애니메이션 부여
            UIView.animate(withDuration: 0.3) {
                CellSnapshotView.value?.center = cell.center
                CellSnapshotView.value?.transform = CGAffineTransform.identity
                CellSnapshotView.value?.alpha = 1.0
                cell.alpha = 1.0
            } completion: { (isFinish) in
                if isFinish {
                    BeforeIndexPath.value = nil
                    CellSnapshotView.value?.removeFromSuperview()
                    CellSnapshotView.value = nil
                }
            }
        }
    }
}
