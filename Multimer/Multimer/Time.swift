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
        let hourUnit = totalSeconds / 3600
        let minuteUnit = (totalSeconds % 3600) / 60
        let secondUnit = (totalSeconds % 3600) % 60
        return (hourUnit, minuteUnit, secondUnit)
    }
    
    var dividedRemainingSeconds: (hour: Int, minute: Int, second: Int) {
        let hourUnit = Int(round(remainingSeconds)) / 3600
        let minuteUnit = (Int(round(remainingSeconds)) % 3600) / 60
        let secondUnit = (Int(round(remainingSeconds)) % 3600) % 60
        return (hourUnit, minuteUnit, secondUnit)
    }
    
    var formattedRemainingSeconds: String {
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
    
    init(hour: Int, minute: Int, second: Int) {
        let totalSeconds = hour * 3600 + minute * 60 + second
        self.init(totalSeconds: totalSeconds, remainingSeconds: Double(totalSeconds))
    }
}

extension Time: ManagedObjectConvertible {
    func toManagedObejct(in context: NSManagedObjectContext) -> TimeMO {
        let timeMO = TimeMO(context: context)
        timeMO.update(totalSeconds: totalSeconds, remainingSeconds: remainingSeconds)
        return timeMO
    }
}
