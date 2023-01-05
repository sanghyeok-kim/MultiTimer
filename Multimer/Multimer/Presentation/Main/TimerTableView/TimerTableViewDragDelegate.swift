//
//  TimerTableViewDragDelegate.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/04.
//

import UIKit

//final class TimerTableViewDragDelegate: NSObject, UITableViewDragDelegate {
//
////    1. 사용자가 드래그 제스처 실행시 -> 테이블뷰는 드래그 세션을 생성하고, 이 메소드를 호출한다.
//    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        //2. 제공된 index path를 이용해서 드래그 아이템을 생성할 행을 결정한다.
//        let timer = tableViewDataSource.timers[indexPath.row]
//
//        //3. 하나 이상의 NSItemProvider 객체를 생성한다. Item provider 들을 이용해서 테이블의 행에 들어갈 데이터를 표현한다.
//        let itemProvider = NSItemProvider(object: timer)
////
//        //4. 옵셔널) 각 드래그 아이템의 localObject 프로퍼티에 값을 할당하는 것을 고려한다. 이 단계는 안해도 되지만 앱에서 드래그 드롭을 하는 것을 더 빠르게 만들어줄 수 있다.
//
//        //5. 각 item provider 객체를 UIDragItem 객체로 감싼다.
//        let dragItems = [
//            UIDragItem(itemProvider: itemProvider)
//        ]
//
//        //6. 드래그 아이템을 반환한다.
//        return dragItems
//    }
//}
//
//extension MainViewController: UITableViewDragDelegate {
//
//
//    //1. 사용자가 드래그 제스처 실행시 -> 테이블뷰는 드래그 세션을 생성하고, 이 메소드를 호출한다.
//    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        //2. 제공된 index path를 이용해서 드래그 아이템을 생성할 행을 결정한다.
//        let timer = tableViewDataSource.timers[indexPath.row]
//
//        //3. 하나 이상의 NSItemProvider 객체를 생성한다. Item provider 들을 이용해서 테이블의 행에 들어갈 데이터를 표현한다.
//        let itemProvider = NSItemProvider(object: timer)
//
//        //4. 옵셔널) 각 드래그 아이템의 localObject 프로퍼티에 값을 할당하는 것을 고려한다. 이 단계는 안해도 되지만 앱에서 드래그 드롭을 하는 것을 더 빠르게 만들어줄 수 있다.
//
//        //5. 각 item provider 객체를 UIDragItem 객체로 감싼다.
//        let dragItems = [
//            UIDragItem(itemProvider: itemProvider)
//        ]
//
//        //6. 드래그 아이템을 반환한다.
//        return dragItems
//    }
//}
