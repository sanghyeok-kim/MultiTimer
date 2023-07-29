//
//  UITextField+Rx+textChanged.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/09.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {
    var textChanged: ControlEvent<String> {
        let source: Observable<String> = base.rx.controlEvent(.editingChanged)
            .compactMap { _ in
                return self.base.text
            }
        return ControlEvent(events: source)
    }
}
