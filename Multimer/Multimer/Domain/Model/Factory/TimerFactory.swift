//
//  TimerFactory.swift
//  Multimer
//
//  Created by 김상혁 on 2023/01/06.
//

import Foundation

struct TimerFactory {
    static func generateMock() -> [Timer] {
        return [Timer(name: "알림1", tag: Tag(color: .navy), time: Time(hour: 0, minute: 0, second: 20), index: 0),
                Timer(name: "알림2", tag: Tag(color: .red), time: Time(hour: 0, minute: 0, second: 17), index: 1),
                Timer(name: "알림3", tag: Tag(color: .orange), time: Time(hour: 0, minute: 0, second: 15), index: 2),
                Timer(name: "알림4", tag: nil, type: .countUp, index: 3),
                Timer(name: "알림5", tag: Tag(color: .red), time: Time(hour: 0, minute: 0, second: 10), index: 4),
                Timer(name: "알림6", tag: Tag(color: .label), time: Time(hour: 0, minute: 0, second: 14), index: 5),
                Timer(name: "알림7", tag: Tag(color: .orange), time: Time(hour: 2, minute: 10, second: 20), index: 6),
                Timer(name: "알림8", tag: Tag(color: .navy), time: Time(hour: 1, minute: 13, second: 30), index: 7),
                Timer(name: "알림9", tag: nil, type: .countUp, index: 8),
                Timer(name: "알림10", tag: Tag(color: .orange), time: Time(hour: 0, minute: 10, second: 20), index: 9),
                Timer(name: "알림11", tag: Tag(color: .purple), time: Time(hour: 1, minute: 10, second: 20), index: 10),
                Timer(name: "알림12", tag: Tag(color: .pink), type: .countUp, index: 11),
                Timer(name: "알림13", tag: Tag(color: .navy), time: Time(hour: 2, minute: 10, second: 20), index: 12),
                Timer(name: "알림14", tag: Tag(color: .red), time: Time(hour: 15, minute: 10, second: 20), index: 13),
                Timer(name: "알림15", tag: Tag(color: .navy), time: Time(hour: 3, minute: 10, second: 20), index: 14),
                Timer(name: "알림16", tag: Tag(color: .orange), time: Time(hour: 2, minute: 10, second: 20), index: 15),
                Timer(name: "알림17", tag: Tag(color: .orange), time: Time(hour: 4, minute: 10, second: 20), index: 16),
                Timer(name: "알림18", tag: Tag(color: .cyan), type: .countUp, index: 17),
                Timer(name: "알림19", tag: Tag(color: .navy), time: Time(hour: 5, minute: 10, second: 20), index: 18),
                Timer(name: "알림20", tag: Tag(color: .pink), type: .countUp, index: 19),
                Timer(name: "알림21", tag: Tag(color: .purple), time: Time(hour: 1, minute: 1, second: 21), index: 20),
                Timer(name: "알림22", tag: Tag(color: .cyan), time: Time(hour: 0, minute: 0, second: 7), index: 21),
                Timer(name: "알림23", tag: Tag(color: .navy), time: Time(hour: 0, minute: 0, second: 10), index:  22)]
    }
}
