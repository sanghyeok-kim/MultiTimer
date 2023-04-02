//
//  RepeatCountView.swift
//  Multimer
//
//  Created by 김상혁 on 2023/03/13.
//

import RxSwift
import RxRelay

final class RepeatCountView: UIView {
    
    let repeatCountDidSet = PublishRelay<Int>()
    private let disposeBag = DisposeBag()
    
    private lazy var repeatCountLabel: UILabel = {
        let label = UILabel()
        label.text = "반복"
        return label
    }()
    
    private lazy var repeatCountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0"
        textField.textAlignment = .right
        textField.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()
    
    private lazy var repeatCountStepper: UIStepper = {
        let stepper = UIStepper()
        return stepper
    }()
    
    private lazy var repeatCountStackView: UIStackView = {
        let innerStackView = UIStackView(arrangedSubviews: [repeatCountLabel, repeatCountTextField, repeatCountStepper])
        innerStackView.setCustomSpacing(20, after: repeatCountTextField)
//        stackView.layer.borderWidth = 1
//        stackView.layer.cornerRadius = 8
//        stackView.layer.borderColor = UIColor.systemGray.cgColor
        innerStackView.alignment = .center
        innerStackView.axis = .horizontal
        let containerStackView = UIStackView(arrangedSubviews: [SeparatorView(), innerStackView, SeparatorView()])
        containerStackView.axis = .vertical
        containerStackView.spacing = 12
        containerStackView.distribution = .equalSpacing
        return containerStackView
    }()
    
//    private lazy var timePickerViewDataSource = TimePickerViewDataSource()
//    private lazy var tiemPickerViewDelegate = TimePickerViewDelegate()
//    private lazy var timePickerView: TimePickerView = {
//        let pickerView = TimePickerView()
//        pickerView.dataSource = timePickerViewDataSource
//        pickerView.delegate = tiemPickerViewDelegate
//        return pickerView
//    }()
    
    init() {
        super.init(frame: .zero)
        repeatCountTextField.rx.textChanged
            .orEmpty
            .skip(1)
            .compactMap { Int($0) }
            .bind(to: repeatCountDidSet)
            .disposed(by: disposeBag)
        
        addSubview(repeatCountStackView)
        
        repeatCountStackView.translatesAutoresizingMaskIntoConstraints = false
        repeatCountStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        repeatCountStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        repeatCountStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        repeatCountStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

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
