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
    var name: String
    var tag: Tag?
    var time: Time
//    var sound:
//    var repeatCount
    
    var totalSeconds: Int {
        return time.totalSeconds
    }
    
    // Default Timer Setting
    init(name: String = "타이머", tag: Tag? = nil, time: Time = Time()) {
        self.name = name
        self.tag = tag
        self.time = time
    }
    
    init(timer: Timer, time: Time) {
        self.name = timer.name
        self.tag = timer.tag
        self.time = time
    }
    
//    static func generateMock() -> [Timer] {
//        return [Timer(name: "알림1", tag: "태그1", time: Time(hour: 1, minute: 10, second: 20)),
//                Timer(name: "알림2", tag: "태그2", time: Time(hour: 0, minute: 0, second: 18)),
//                Timer(name: "알림3", tag: "태그3", time: Time(hour: 0, minute: 0, second: 16)),
//                Timer(name: "알림4", tag: "태그4", time: Time(hour: 3, minute: 0, second: 20)),
//                Timer(name: "알림5", tag: "태그5", time: Time(hour: 0, minute: 0, second: 10)),
//                Timer(name: "알림6", tag: "태그6", time: Time(hour: 0, minute: 0, second: 15)),
//                Timer(name: "알림7", tag: "태그7", time: Time(hour: 2, minute: 10, second: 20)),
//                Timer(name: "알림8", tag: "태그8", time: Time(hour: 1, minute: 13, second: 30)),
//                Timer(name: "알림9", tag: "태그9", time: Time(hour: 20, minute: 50, second: 50)),
//                Timer(name: "알림10", tag: "태그10", time: Time(hour: 0, minute: 10, second: 20)),
//                Timer(name: "알림11", tag: "태그11", time: Time(hour: 1, minute: 10, second: 20)),
//                Timer(name: "알림12", tag: "태그12", time: Time(hour: 10, minute: 10, second: 20)),
//                Timer(name: "알림13", tag: "태그13", time: Time(hour: 2, minute: 10, second: 20)),
//                Timer(name: "알림14", tag: "태그14", time: Time(hour: 15, minute: 10, second: 20)),
//                Timer(name: "알림15", tag: "태그15", time: Time(hour: 3, minute: 10, second: 20)),
//                Timer(name: "알림16", tag: "태그16", time: Time(hour: 2, minute: 10, second: 20)),
//                Timer(name: "알림17", tag: "태그17", time: Time(hour: 4, minute: 10, second: 20)),
//                Timer(name: "알림18", tag: "태그18", time: Time(hour: 0, minute: 10, second: 20)),
//                Timer(name: "알림19", tag: "태그19", time: Time(hour: 5, minute: 10, second: 20)),
//                Timer(name: "알림20", tag: "태그20", time: Time(hour: 20, minute: 20, second: 20)),
//                Timer(name: "알림21", tag: "태그21", time: Time(hour: 21, minute: 21, second: 21)),
//                Timer(name: "알림22", tag: "태그22", time: Time(hour: 22, minute: 22, second: 22)),
//                Timer(name: "알림23", tag: "태그23", time: Time(hour: 23, minute: 23, second: 23))]
    
    static func generateMock() -> [Timer] {
        return [Timer(name: "알림1", tag: Tag(color: .blue), time: Time(hour: 1, minute: 10, second: 20)),
                Timer(name: "알림2", tag: Tag(color: .red), time: Time(hour: 0, minute: 0, second: 7)),
                Timer(name: "알림3", tag: Tag(color: .brown), time: Time(hour: 0, minute: 0, second: 5)),
                Timer(name: "알림4", tag: nil, time: Time(hour: 3, minute: 0, second: 20)),
                Timer(name: "알림5", tag: Tag(color: .red), time: Time(hour: 0, minute: 0, second: 10)),
                Timer(name: "알림6", tag: Tag(color: .blue), time: Time(hour: 0, minute: 0, second: 15)),
                Timer(name: "알림7", tag: Tag(color: .yellow), time: Time(hour: 2, minute: 10, second: 20)),
                Timer(name: "알림8", tag: Tag(color: .indigo), time: Time(hour: 1, minute: 13, second: 30)),
                Timer(name: "알림9", tag: Tag(color: .green), time: Time(hour: 20, minute: 50, second: 50)),
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
                Timer(name: "알림20", tag: Tag(color: .pink), time: Time(hour: 20, minute: 20, second: 20)),
                Timer(name: "알림21", tag: Tag(color: .purple), time: Time(hour: 21, minute: 21, second: 21)),
                Timer(name: "알림22", tag: Tag(color: .green), time: Time(hour: 22, minute: 22, second: 22)),
                Timer(name: "알림23", tag: Tag(color: .indigo), time: Time(hour: 23, minute: 23, second: 23))]
    
//    static func generateMock() -> [Timer] {
//        return [Timer(name: "알림1", tag: Tag(index: 1, color: .blue), time: Time(hour: 1, minute: 10, second: 20)),
//                Timer(name: "알림2", tag: Tag(index: 0, color: .red), time: Time(hour: 0, minute: 0, second: 7)),
//                Timer(name: "알림3", tag: nil, time: Time(hour: 0, minute: 0, second: 5)),
//                Timer(name: "알림4", tag: Tag(index: 4, color: .yellow), time: Time(hour: 3, minute: 0, second: 20)),
//                Timer(name: "알림5", tag: Tag(index: 1, color: .red), time: Time(hour: 0, minute: 0, second: 10)),
//                Timer(name: "알림6", tag: Tag(index: 1, color: .blue), time: Time(hour: 0, minute: 0, second: 15)),
//                Timer(name: "알림7", tag: Tag(index: 4, color: .yellow), time: Time(hour: 2, minute: 10, second: 20)),
//                Timer(name: "알림8", tag: Tag(index: 9, color: .indigo), time: Time(hour: 1, minute: 13, second: 30)),
//                Timer(name: "알림9", tag: Tag(index: 2, color: .green), time: Time(hour: 20, minute: 50, second: 50)),
//                Timer(name: "알림10", tag: Tag(index: 8, color: .orange), time: Time(hour: 0, minute: 10, second: 20)),
//                Timer(name: "알림11", tag: Tag(index: 3, color: .purple), time: Time(hour: 1, minute: 10, second: 20)),
//                Timer(name: "알림12", tag: Tag(index: 6, color: .pink), time: Time(hour: 10, minute: 10, second: 20)),
//                Timer(name: "알림13", tag: Tag(index: 1, color: .blue), time: Time(hour: 2, minute: 10, second: 20)),
//                Timer(name: "알림14", tag: Tag(index: 0, color: .red), time: Time(hour: 15, minute: 10, second: 20)),
//                Timer(name: "알림15", tag: Tag(index: 5, color: .brown), time: Time(hour: 3, minute: 10, second: 20)),
//                Timer(name: "알림16", tag: Tag(index: 4, color: .yellow), time: Time(hour: 2, minute: 10, second: 20)),
//                Timer(name: "알림17", tag: Tag(index: 8, color: .orange), time: Time(hour: 4, minute: 10, second: 20)),
//                Timer(name: "알림18", tag: Tag(index: 2, color: .green), time: Time(hour: 0, minute: 10, second: 20)),
//                Timer(name: "알림19", tag: Tag(index: 1, color: .blue), time: Time(hour: 5, minute: 10, second: 20)),
//                Timer(name: "알림20", tag: Tag(index: 6, color: .pink), time: Time(hour: 20, minute: 20, second: 20)),
//                Timer(name: "알림21", tag: Tag(index: 3, color: .purple), time: Time(hour: 21, minute: 21, second: 21)),
//                Timer(name: "알림22", tag: Tag(index: 2, color: .green), time: Time(hour: 22, minute: 22, second: 22)),
//                Timer(name: "알림23", tag: Tag(index: 9, color: .indigo), time: Time(hour: 23, minute: 23, second: 23))]
//    }
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
        timerMO.update(name: name, tag: tag, time: time, context: context)
        return timerMO
    }
}
