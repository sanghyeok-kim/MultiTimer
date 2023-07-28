//
//  HomeUseCase.swift
//  Multimer
//
//  Created by 김상혁 on 2023/01/06.
//

import RxSwift

protocol HomeUseCase {
    var fetchedUserTimers: PublishSubject<[Timer]> { get }
    func fetchUserTimers()
    func deleteTimer(target identifier: UUID)
    func moveTimer(target identifier: UUID, to destination: Int)
    func appendTimer(_ timer: Timer)
}
