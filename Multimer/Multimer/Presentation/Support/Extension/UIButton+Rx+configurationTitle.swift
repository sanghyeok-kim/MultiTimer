//
//  UIButton+Rx+configurationTitle.swift
//  Multimer
//
//  Created by 김상혁 on 2023/08/02.
//

import RxSwift

extension Reactive where Base: UIButton {
    var configurationTitle: Binder<String> {
        return Binder(self.base) { button, title in
            var configuration = button.configuration
            configuration?.title = title
            button.configuration = configuration
        }
    }
}
