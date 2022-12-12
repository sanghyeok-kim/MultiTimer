//
//  Timer.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import Foundation
import CoreData

//final class Timer: NSObject, Codable {
struct Timer {
    let identifier: UUID
    var name: String
    var tag: Tag?
    var time: Time
    var state: TimerState
    var expireDate: Date?
    var notificationIdentifier: String?
//    var sound:
//    var repeatCount
    
    var totalSeconds: Int {
        return time.totalSeconds
    }
    
//    var remainingSeconds: Int {
    var remainingSeconds: Double {
        return time.remainingSeconds
    }
    
    init(identifier: UUID = UUID(),
         name: String = "타이머",
         tag: Tag? = nil,
         time: Time = Time(),
         state: TimerState = .ready,
         expireDate: Date? = nil) {
        self.identifier = identifier
        self.name = name
        self.tag = tag
        self.time = time
        self.state = state
        self.expireDate = expireDate
        self.notificationIdentifier = identifier.uuidString
    }
    
    init(timer: Timer, time: Time) {
        self.identifier = timer.identifier
        self.name = timer.name
        self.tag = timer.tag
        self.time = time
        self.state = timer.state
        self.notificationIdentifier = identifier.uuidString
    }
    
    static func generateMock() -> [Timer] {
        return [Timer(name: "알림1", tag: Tag(color: .blue), time: Time(hour: 0, minute: 0, second: 20)),
                Timer(name: "알림2", tag: Tag(color: .red), time: Time(hour: 0, minute: 0, second: 17)),
                Timer(name: "알림3", tag: Tag(color: .brown), time: Time(hour: 0, minute: 0, second: 15)),
                Timer(name: "알림4", tag: nil, time: Time(hour: 0, minute: 0, second: 22)),
                Timer(name: "알림5", tag: Tag(color: .red), time: Time(hour: 0, minute: 0, second: 10)),
                Timer(name: "알림6", tag: nil, time: Time(hour: 0, minute: 0, second: 14)),
                Timer(name: "알림7", tag: Tag(color: .yellow), time: Time(hour: 2, minute: 10, second: 20)),
                Timer(name: "알림8", tag: Tag(color: .indigo), time: Time(hour: 1, minute: 13, second: 30)),
                Timer(name: "알림9", tag: nil, time: Time(hour: 20, minute: 50, second: 50)),
                Timer(name: "알림10", tag: Tag(color: .orange), time: Time(hour: 0, minute: 10, second: 20)),
                Timer(name: "알림11", tag: Tag(color: .purple), time: Time(hour: 1, minute: 10, second: 20)),
                Timer(name: "알림12", tag: Tag(color: .pink), time: Time(hour: 10, minute: 10, second: 20)),
                Timer(name: "알림13", tag: Tag(color: .blue), time: Time(hour: 2, minute: 10, second: 20)),
                Timer(name: "알림14", tag: Tag(color: .red), time: Time(hour: 15, minute: 10, second: 20)),
                Timer(name: "알림15", tag: Tag(color: .brown), time: Time(hour: 3, minute: 10, second: 20)),
                Timer(name: "알림16", tag: Tag(color: .yellow), time: Time(hour: 2, minute: 10, second: 20)),
                Timer(name: "알림17", tag: Tag(color: .orange), time: Time(hour: 4, minute: 10, second: 20)),
                Timer(name: "알림18", tag: Tag(color: .green), time: Time(hour: 0, minute: 10, second: 20)),
                Timer(name: "알림19", tag: Tag(color: .blue), time: Time(hour: 5, minute: 10, second: 20)),
                Timer(name: "알림20", tag: Tag(color: .pink), time: Time(hour: 0, minute: 0, second: 20)),
                Timer(name: "알림21", tag: Tag(color: .purple), time: Time(hour: 1, minute: 1, second: 21)),
                Timer(name: "알림22", tag: Tag(color: .green), time: Time(hour: 0, minute: 0, second: 7)),
                Timer(name: "알림23", tag: Tag(color: .indigo), time: Time(hour: 0, minute: 0, second: 10))]
}

//extension Timer: NSItemProviderReading {
//    static var writableTypeIdentifiersForItemProvider: [String] {
//        return [String(kUTTypeData)]
//    }
//
//    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
//        let progress = Progress(totalUnitCount: 100)
//
//        do {
//            let data = try JSONEncoder().encode(self)
//            progress.completedUnitCount = 100
//            completionHandler(data, nil)
//        } catch {
//            completionHandler(nil, error)
//        }
//
//        return progress
//    }
//}
//
//extension Timer: NSItemProviderWriting {
//    static var readableTypeIdentifiersForItemProvider: [String] {
//        return [String(kUTTypeData)]
//    }
//
//    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Timer {
//        let decoder = JSONDecoder()
//        do {
//            let timer = try decoder.decode(Timer.self, from: data)
//            return timer
//        } // catch?
//    }
}

extension Timer: Equatable {
    static func == (lhs: Timer, rhs: Timer) -> Bool {
        return (lhs.name == rhs.name) && (lhs.tag == rhs.tag) && (lhs.time == rhs.time)
    }
}

extension Timer: ManagedObjectConvertible {
    func toManagedObejct(in context: NSManagedObjectContext) -> TimerMO {
        let timerMO = TimerMO(context: context)
        timerMO.update(identifier: identifier, name: name, tag: tag, time: time, state: state, context: context)
        return timerMO
    }
}
