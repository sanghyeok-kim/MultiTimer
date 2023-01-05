//
//  TimeFactory.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/16.
//

import Foundation

struct TimeFactory {
    static func createDefaultTime() -> Time {
        return Time(totalSeconds: .zero, remainingSeconds: .zero)
    }
    
    static func createResetTime(of time: Time) -> Time {
        return Time(totalSeconds: time.totalSeconds, remainingSeconds: Double(time.totalSeconds))
    }
    
    static func createExpiredTime(of time: Time) -> Time {
        return Time(totalSeconds: time.totalSeconds, remainingSeconds: .zero)
    }
}
