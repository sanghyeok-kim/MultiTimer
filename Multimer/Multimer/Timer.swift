//
//  Timer.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import Foundation

final class Timer: NSObject, Codable {
    let id: UUID
    var name: String?
    var tag: String?
    var time: Time
//    var sound:
//    var repeatCount
    
    init(name: String? = nil, tag: String? = nil, time: Time) {
        self.id = UUID()
        self.name = name
        self.tag = tag
        self.time = time
    }
    
    static func generateMock() -> [Timer] {
        return [Timer(name: "알림1", tag: "태그1", time: Time(hour: 1, minute: 10, second: 20)),
                Timer(name: "알림2", tag: "태그2", time: Time(hour: 0, minute: 0, second: 18)),
                Timer(name: "알림3", tag: "태그3", time: Time(hour: 0, minute: 0, second: 16)),
                Timer(name: "알림4", tag: "태그4", time: Time(hour: 3, minute: 0, second: 20)),
                Timer(name: "알림5", tag: "태그5", time: Time(hour: 0, minute: 0, second: 10)),
                Timer(name: "알림6", tag: "태그6", time: Time(hour: 0, minute: 0, second: 15)),
                Timer(name: "알림7", tag: "태그7", time: Time(hour: 2, minute: 10, second: 20)),
                Timer(name: "알림8", tag: "태그8", time: Time(hour: 1, minute: 13, second: 30)),
                Timer(name: "알림9", tag: "태그9", time: Time(hour: 20, minute: 50, second: 50)),
                Timer(name: "알림10", tag: "태그10", time: Time(hour: 0, minute: 10, second: 20)),
                Timer(name: "알림11", tag: "태그11", time: Time(hour: 1, minute: 10, second: 20)),
                Timer(name: "알림12", tag: "태그12", time: Time(hour: 10, minute: 10, second: 20)),
                Timer(name: "알림13", tag: "태그13", time: Time(hour: 2, minute: 10, second: 20)),
                Timer(name: "알림14", tag: "태그14", time: Time(hour: 15, minute: 10, second: 20)),
                Timer(name: "알림15", tag: "태그15", time: Time(hour: 3, minute: 10, second: 20)),
                Timer(name: "알림16", tag: "태그16", time: Time(hour: 2, minute: 10, second: 20)),
                Timer(name: "알림17", tag: "태그17", time: Time(hour: 4, minute: 10, second: 20)),
                Timer(name: "알림18", tag: "태그18", time: Time(hour: 0, minute: 10, second: 20)),
                Timer(name: "알림19", tag: "태그19", time: Time(hour: 5, minute: 10, second: 20)),
                Timer(name: "알림20", tag: "태그20", time: Time(hour: 20, minute: 20, second: 20)),
                Timer(name: "알림21", tag: "태그21", time: Time(hour: 21, minute: 21, second: 21)),
                Timer(name: "알림22", tag: "태그22", time: Time(hour: 22, minute: 22, second: 22)),
                Timer(name: "알림23", tag: "태그23", time: Time(hour: 23, minute: 23, second: 23))]
    }
}
}
