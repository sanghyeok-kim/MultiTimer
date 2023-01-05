//
//  UITextField+Rx+textChanged.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/09.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {
    public var textChanged: ControlProperty<String?> {
        return base.rx.controlProperty(
            editingEvents: [.editingChanged, .valueChanged],
            getter: { textField in
                textField.text
            }, setter: { textField, value in
                if textField.text != value {
                    textField.text = value
                }
            }
        )
    }
}
