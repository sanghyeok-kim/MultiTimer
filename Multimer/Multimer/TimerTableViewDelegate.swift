//
//  TimerTableViewDelegate.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import UIKit

final class TimerTableViewDelegate: NSObject, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
