//
//  UIView+Fade.swift
//  Multimer
//
//  Created by 김상혁 on 2023/02/13.
//

import UIKit

extension UIView {
    func shouldFadeIn(bool: Bool, withDuration timeInterval: TimeInterval) {
        switch bool {
        case true:
            fadeIn(withDuration: timeInterval)
        case false:
            fadeOut(withDuration: timeInterval)
        }
    }
    
    func fadeIn(withDuration timeInterval: TimeInterval) {
        self.isHidden = false
        UIView.animate(withDuration: timeInterval) {
            self.alpha = 1.0
        }
    }
    
    func fadeOut(withDuration timeInterval: TimeInterval) {
        UIView.animate(withDuration: timeInterval) {
            self.alpha = .zero
        } completion: { _ in
            self.isHidden = true
        }
    }
}
