//
//  SeparatorView.swift
//  Multimer
//
//  Created by 김상혁 on 2023/04/02.
//

import UIKit

final class SeparatorView: UIView {
    init() {
        super.init(frame: .zero)
        backgroundColor = .systemGray
        heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
