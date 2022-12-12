//
//  Time.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import Foundation
import CoreData

struct Time: Codable, Equatable {

    var totalSeconds: Int
    var remainingSeconds: Double
    
    var dividedTotalSeconds: (hour: Int, minute: Int, second: Int) {
        return (totalSeconds / 3600, (totalSeconds % 3600) / 60, (totalSeconds % 3600) % 60)
    }
    
    var dividedRemainingSeconds: (hour: Int, minute: Int, second: Int) { // TODO: 변수명 다시 생각해보자
        return (Int(round(remainingSeconds)) / 3600, (Int(round(remainingSeconds)) % 3600) / 60, (Int(round(remainingSeconds)) % 3600) % 60)
    }
    
    var formattedString: String {
        let (hour, minute, second) = dividedRemainingSeconds
        let hourString = hour == .zero ? "" : String(format: "%02d:", hour)
        let minuteString = String(format: "%02d:", minute)
        let secondString = String(format: "%02d", second)
        return "\(hourString)\(minuteString)\(secondString)"
    }
    
    init(totalSeconds: Int, remainingSeconds: Double) {
        self.totalSeconds = totalSeconds
        self.remainingSeconds = remainingSeconds
    }
    
    init(totalSeconds: Int = .zero) {
        self.totalSeconds = totalSeconds
        self.remainingSeconds = Double(totalSeconds)
    }
    
    init(hour: Int, minute: Int, second: Int) {
        let totalSeconds = hour * 3600 + minute * 60 + second
        self.init(totalSeconds: totalSeconds, remainingSeconds: Double(totalSeconds))
    }
    
    func turnBackTime() -> Time {
        return Time(totalSeconds: totalSeconds)
    }
    
    func expireTime() -> Time {
        return Time(totalSeconds: totalSeconds, remainingSeconds: .zero)
    }
}

extension Time: ManagedObjectConvertible {
    func toManagedObejct(in context: NSManagedObjectContext) -> TimeMO {
        let timeMO = TimeMO(context: context)
        timeMO.update(totalSeconds: totalSeconds, remainingSeconds: remainingSeconds)
        return timeMO
    }
}
