//
//  Time.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import Foundation

struct Time: Codable {
    var totalSeconds: Int
    
    var dividedSeconds: (hour: Int, minute: Int, second: Int) { // TODO: 변수명 다시 생각해보자
        return (totalSeconds / 3600, (totalSeconds % 3600) / 60, (totalSeconds % 3600) % 60)
    }
    
    var formattedString: String {
        let (hour, minute, second) = dividedSeconds
        let hourString = hour == 0 ? "" : String(format: "%02d:", hour)
        let minuteString = String(format: "%02d:", minute)
        let secondString = String(format: "%02d", second)
        return "\(hourString)\(minuteString)\(secondString)"
    }
    
    init(totalSeconds: Int = 0) {
        self.totalSeconds = totalSeconds
    }
    
    init(hour: Int, minute: Int, second: Int) {
        let totalSeconds = hour * 3600 + minute * 60 + second
        self.init(totalSeconds: totalSeconds)
    }
}

