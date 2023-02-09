//
//  Constant.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/28.
//

import UIKit

enum Constant {
    enum SFSymbolName {
        static let trashCircle = "trash.circle"
        static let trashFill = "trash.fill"
        
        static let stopCircle = "stop.circle"
        static let stopFill = "stop.fill"
        
        static let playCircle = "play.circle"
        static let playFill = "play.fill"
        static let playCircleFill = "play.circle.fill"
        
        static let pauseCircle = "pause.circle"
        static let pauseFill = "pause.fill"
        static let pauseCircleFill = "pause.circle.fill"
        
        static let checkmark = "checkmark"
        static let checkmarkCircle = "checkmark.circle"
        
        static let plus = "plus"
        
        static let hourglassTophalfFilled = "hourglass.tophalf.filled"
        static let stopwatchFill = "stopwatch.fill"
    }
    
    
    enum NotificationCenter {
        static let showSwipeToStopNotice = "showSwipeToStopNotice"
    }
    
    enum UserDefaultsKey {
        static let isFirstRun = "isFirstRun"
    }
}
