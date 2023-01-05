//
//  TimerTableViewDropDelegate.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/04.
//

import UIKit

//final class TimerTableViewDropDelegate: NSObject, UITableViewDropDelegate {
//    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
//        return session.canLoadObjects(ofClass: Timer.self)
//    }
//
//    ///8.  만약 포함시킬 수 있으면, 테이블 뷰는 데이터가 드롭될 수 있는 곳을 판단하기 위해 다른 메서드를 호출하기 시작한다.
//    /// tableView(_:dropSessionDidUpdate:withDestinationIndexPath:) 메서드를 호출해서 변화를 알린다.
//    /// 이 메서드를 구현하는 것도 옵션이지만, 드래그된 컨텐츠가 어떻게 합쳐질지 시각적인 피드백을 테이블 뷰가 제공할 수 있기 때문에 구현하는 것이 권장된다.
//    func tableView(
//        _ tableView: UITableView,
//        dropSessionDidUpdate session: UIDropSession,
//        withDestinationIndexPath destinationIndexPath: IndexPath?
//    ) -> UITableViewDropProposal {
//        ///UITableViewDropProposal 객체를 생성해서 리턴한다.
//        ///예를 들어, 데이터 소스에 새로운 행으로 컨텐츠를 삽입하고 싶을 수도 있고 특정 index path에 있는 행에 데이터를 추가하고 싶을 수도 있다.
//        ///메서드가 자주 호출되기 때문에, 가능한 빨리 개발자가 제안하는 바를 리턴해야 한다.
//        ///만약 이 메서드를 구현하지 않는다면, 테이블 뷰는 드롭할 때 시각적인 피드백을 주지 않는다.
//        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
////        return UITableViewDropProposal(operation: .move)
//    }
//
//    ///9. 사용자가 스크린에서 손가락을 뗄 때, 테이블 뷰는 drop delegate의 tableView(_:performDropWith) 메서드를 호출한다.
//    ///  이 메서드를 구현해서 드롭된 데이터를 다룬다.
//    ///  구현에서는, 드래그 된 데이터를 가져오고, 테이블 뷰의 데이터 소스를 업데이트 하고, 필요하면 테이블 뷰에 새로운 행을 추가한다.
//    ///
//    ///  만약 컨텐츠가 테이블 뷰에서 가져와진 거라면, 테이블 뷰 API를 이용해서 드래그된 행을 원래 있던 곳에서 삭제하고 새로운 곳에 넣을 수 있다.
//    ///  테이블 뷰 밖에서 온 컨텐츠에 대해서는 localObject 프로퍼티(앱 안의 컨텐츠)를 사용하거나 데이터를 가져오기 위해 NSItemProvider 객체를 이용하고 데이터를 삽입한다.
//    ///
//    ///tableView(_:performDropWith:) 메서드에서, 아래의 것들을 한다.
//    ///  1. 제공된 drop coordinator 객체의 items 프로퍼티를 반복한다.
//    ///  2. 각 아이템에서, 컨텐츠를 어떻게 관리하고 싶은지를 결정한다.
//    ///  - 아이템의 sourceIndexPath 가 값을 포함하고 있다면, 아이템은 테이블 뷰에서 온 것이다. 아이템을 현재 위치에서 삭제하고 새로운 index path에 넣기 위해 batch update를 한다.
//    ///  - 만약 드래그된 아이템의 localObject 프로퍼티가 집합이라면, 컨텐츠는 앱의 어디선가 온 것이고, 앱은 새로운 행을 추가하거나 이미 존재하는 행을 업데이트 해야 한다.
//    ///  - 다른 옵션이 없을 경우, 드래그 아이템의 itemProvider의 NSItemProvider를 이용해서 데이터를 비동기적으로 가져오고 아이템을 삽입하거나 업데이트 한다.
//    ///  3. 데이터 소스를 업데이트 하고, 테이블 뷰에 필요한 아이템을 삽입하거나 이동시킨다.
//    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
//
//        ///First, the easier part: figuring out where to drop rows.
//        ///The performDropWith method passes us an object of the class UITableViewDropCoordinator,
//        ///which has a destinationIndexPath property telling us where the user wants to drop the data.
//        let destinationIndexPath: IndexPath
//
//        ///However, it's optional: it will be nil if they dragged their data over some empty cells in our table view,
//        if let indexPath = coordinator.destinationIndexPath {
//            destinationIndexPath = indexPath
//        } else {
//            ///and if that happens we're going to assume they wanted to drop the data at the end of the table.
//            let section = tableView.numberOfSections - 1
//            let row = tableView.numberOfRows(inSection: section)
//            destinationIndexPath = IndexPath(row: row, section: section)
//        }
//
//        coordinator.session.loadObjects(ofClass: Timer.self) { items in
//            // convert the item provider array to a string array or bail out
//            guard let timers = items as? [Timer] else { return }
//
//            // create an empty array to track rows we've copied
//            var indexPaths = [IndexPath]()
//
//            // loop over all the strings we received
//            for (index, timer) in timers.enumerated() {
//                // create an index path for this new row, moving it down depending on how many we've already inserted
//
//                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
//
//                // keep track of this new row
////                if tableView == self.tableView {
////                    self.tableViewDataSource.timers.insert(timer, at: indexPath.row)
////                }
//
//                indexPaths.append(indexPath)
//            }
//
//            // insert them all into the table view at once
//            tableView.insertRows(at: indexPaths, with: .automatic)
//        }
//    }
//}

//extension MainViewController: UITableViewDropDelegate {
//    ///7. 컨텐츠가 경계 안에서 드래그 될 때, 테이블 뷰는 drop delegate에게 드래그된 데이터를 받을 수 있는지를 물어본다.
//    ///  처음에, 테이블 뷰는 drop delegate의 tableView(_:canHandle:)를 호출해서 특정 데이터를 데이터 소스에 합칠 수 있는지 판단한다.
//    ///  -> 구현하지 않으면 default로 true를 반환
//    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
//        return session.canLoadObjects(ofClass: Timer.self)
//    }
//
//
//    ///8.  만약 포함시킬 수 있으면, 테이블 뷰는 데이터가 드롭될 수 있는 곳을 판단하기 위해 다른 메서드를 호출하기 시작한다.
//    /// tableView(_:dropSessionDidUpdate:withDestinationIndexPath:) 메서드를 호출해서 변화를 알린다.
//    /// 이 메서드를 구현하는 것도 옵션이지만, 드래그된 컨텐츠가 어떻게 합쳐질지 시각적인 피드백을 테이블 뷰가 제공할 수 있기 때문에 구현하는 것이 권장된다.
//    func tableView(
//        _ tableView: UITableView,
//        dropSessionDidUpdate session: UIDropSession,
//        withDestinationIndexPath destinationIndexPath: IndexPath?
//    ) -> UITableViewDropProposal {
//        ///UITableViewDropProposal 객체를 생성해서 리턴한다.
//        ///예를 들어, 데이터 소스에 새로운 행으로 컨텐츠를 삽입하고 싶을 수도 있고 특정 index path에 있는 행에 데이터를 추가하고 싶을 수도 있다.
//        ///메서드가 자주 호출되기 때문에, 가능한 빨리 개발자가 제안하는 바를 리턴해야 한다.
//        ///만약 이 메서드를 구현하지 않는다면, 테이블 뷰는 드롭할 때 시각적인 피드백을 주지 않는다.
//        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
////        return UITableViewDropProposal(operation: .move)
//    }
//
//    ///9. 사용자가 스크린에서 손가락을 뗄 때, 테이블 뷰는 drop delegate의 tableView(_:performDropWith) 메서드를 호출한다.
//    ///  이 메서드를 구현해서 드롭된 데이터를 다룬다.
//    ///  구현에서는, 드래그 된 데이터를 가져오고, 테이블 뷰의 데이터 소스를 업데이트 하고, 필요하면 테이블 뷰에 새로운 행을 추가한다.
//    ///
//    ///  만약 컨텐츠가 테이블 뷰에서 가져와진 거라면, 테이블 뷰 API를 이용해서 드래그된 행을 원래 있던 곳에서 삭제하고 새로운 곳에 넣을 수 있다.
//    ///  테이블 뷰 밖에서 온 컨텐츠에 대해서는 localObject 프로퍼티(앱 안의 컨텐츠)를 사용하거나 데이터를 가져오기 위해 NSItemProvider 객체를 이용하고 데이터를 삽입한다.
//    ///
//    ///tableView(_:performDropWith:) 메서드에서, 아래의 것들을 한다.
//    ///  1. 제공된 drop coordinator 객체의 items 프로퍼티를 반복한다.
//    ///  2. 각 아이템에서, 컨텐츠를 어떻게 관리하고 싶은지를 결정한다.
//    ///  - 아이템의 sourceIndexPath 가 값을 포함하고 있다면, 아이템은 테이블 뷰에서 온 것이다. 아이템을 현재 위치에서 삭제하고 새로운 index path에 넣기 위해 batch update를 한다.
//    ///  - 만약 드래그된 아이템의 localObject 프로퍼티가 집합이라면, 컨텐츠는 앱의 어디선가 온 것이고, 앱은 새로운 행을 추가하거나 이미 존재하는 행을 업데이트 해야 한다.
//    ///  - 다른 옵션이 없을 경우, 드래그 아이템의 itemProvider의 NSItemProvider를 이용해서 데이터를 비동기적으로 가져오고 아이템을 삽입하거나 업데이트 한다.
//    ///  3. 데이터 소스를 업데이트 하고, 테이블 뷰에 필요한 아이템을 삽입하거나 이동시킨다.
//    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
//
//        ///First, the easier part: figuring out where to drop rows.
//        ///The performDropWith method passes us an object of the class UITableViewDropCoordinator,
//        ///which has a destinationIndexPath property telling us where the user wants to drop the data.
//        let destinationIndexPath: IndexPath
//
//        ///However, it's optional: it will be nil if they dragged their data over some empty cells in our table view,
//        if let indexPath = coordinator.destinationIndexPath {
//            destinationIndexPath = indexPath
//        } else {
//            ///and if that happens we're going to assume they wanted to drop the data at the end of the table.
//            let section = tableView.numberOfSections - 1
//            let row = tableView.numberOfRows(inSection: section)
//            destinationIndexPath = IndexPath(row: row, section: section)
//        }
//
//        coordinator.session.loadObjects(ofClass: Timer.self) { items in
//            // convert the item provider array to a string array or bail out
//            guard let timers = items as? [Timer] else { return }
//
//            // create an empty array to track rows we've copied
//            var indexPaths = [IndexPath]()
//
//            // loop over all the strings we received
//            for (index, timer) in timers.enumerated() {
//                // create an index path for this new row, moving it down depending on how many we've already inserted
//
//                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
//
//                // keep track of this new row
//                if tableView == self.tableView {
//                    self.tableViewDataSource.timers.insert(timer, at: indexPath.row)
//                }
//
//                indexPaths.append(indexPath)
//            }
//
//            // insert them all into the table view at once
//            tableView.insertRows(at: indexPaths, with: .automatic)
//        }
//    }
//}
