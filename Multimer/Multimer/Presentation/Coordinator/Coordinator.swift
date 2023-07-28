//
//  Coordinator.swift
//  Multimer
//
//  Created by 김상혁 on 2023/07/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinatorMap: [CoordinatorType: Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var `type`: CoordinatorType { get }
    
    func start()
}

extension Coordinator {
    func add(childCoordinator: Coordinator) {
        childCoordinatorMap[childCoordinator.type] = childCoordinator
    }
    
    func remove(childCoordinator type: CoordinatorType) {
        childCoordinatorMap.removeValue(forKey: type)
    }
}
