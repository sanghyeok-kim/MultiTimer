//
//  SKStoreReviewController+requestReviewInCurrentScene.swift
//  Multimer
//
//  Created by 김상혁 on 2023/08/11.
//

import Foundation
import StoreKit

extension SKStoreReviewController {
    static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: {
            $0.activationState == .foregroundActive
        }) as? UIWindowScene {
           requestReview(in: scene)
        }
    }
}
