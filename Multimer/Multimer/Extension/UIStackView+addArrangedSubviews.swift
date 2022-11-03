//
//  UIStackView+addArrangedSubviews.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}
