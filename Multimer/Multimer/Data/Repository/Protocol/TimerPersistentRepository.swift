//
//  TimerPersistentRepository.swift
//  Multimer
//
//  Created by 김상혁 on 2023/01/06.
//

import RxSwift

protocol TimerPersistentRepository {
    func create(timer: Timer)
    func fetchTimers() -> Observable<[Timer]>
    func updateTimer(target identifier: UUID,
        name: String?,
        tag: Tag?,
        time: Time?,
        state: TimerState?,
        expireDate: Date?,
        startDate: Date?,
        type: TimerType?
    ) -> Completable
    func saveTimeOfTimer(
        target identifier: UUID,
        time: Time?,
        state: TimerState?,
        expireDate: Date?,
        startDate: Date?
    )
    func deleteTimer(target identifier: UUID) -> Completable
    func reindexTimers()
    func updateTimerIndex(target identifier: UUID, to changedIndex: Int)
    func findTimer(target identifier: UUID) -> Observable<TimerMO>
}
