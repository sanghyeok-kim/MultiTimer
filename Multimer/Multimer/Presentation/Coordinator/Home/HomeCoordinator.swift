//
//  HomeCoordinator.swift
//  Multimer
//
//  Created by 김상혁 on 2023/07/28.
//

import Foundation

protocol HomeCoordinator: Coordinator {
    func coordinate(by coordinateAction: HomeCoordinatorAction)
}
