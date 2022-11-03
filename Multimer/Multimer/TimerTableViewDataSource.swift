//
//  TimerTableViewDataSource.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import UIKit

final class TimerTableViewDataSource: NSObject, UITableViewDataSource {
    
    let timers = [Timer(id: UUID(), name: "알림1", tag: "태그1", time: "10:20"),
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
}
