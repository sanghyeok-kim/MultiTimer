//
//  NameTextField.swift
//  Multimer
//
//  Created by 김상혁 on 2023/02/08.
//

import RxSwift
import RxRelay

final class NameTextField: UITextField {
    
    let defaultNameBarButtonDidTap = PublishRelay<Void>()
    let defaultName = PublishRelay<String>()
    
    private lazy var flexibleSpaceButton: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
    }()
    
    private lazy var defaultNameBarButton: UIBarButtonItem = {
        return UIBarButtonItem(
            title: LocalizableString.defaultName.localized,
            style: .done,
            target: nil,
            action: #selector(tapDefaultNameBarButton)
        )
    }()
    
    private lazy var doneBarButton: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .done,
            target: nil,
            action: #selector(tapDoneBarButton)
        )
    }()
    
    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.backgroundColor = .systemBackground
        toolbar.sizeToFit()
        return toolbar
    }()
    
    private let disposeBag = DisposeBag()
    
    init(toolbarType: ToolbarType) {
        super.init(frame: .zero)
        configureUI()
        setToolbarItems(by: toolbarType)
        bindDefaultName()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindDefaultName() {
        defaultName
            .bind(to: rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setToolbarItems(by toolbarType: ToolbarType) {
        switch toolbarType {
        case .create:
            toolbar.setItems([defaultNameBarButton, flexibleSpaceButton, doneBarButton], animated: false)
        case .setting:
            toolbar.setItems([flexibleSpaceButton, doneBarButton], animated: false)
        }
//        inputAccessoryView = toolbar
    }
}

// MARK: Objc Selector Methods

private extension NameTextField {
    @objc private func tapDoneBarButton() {
        resignFirstResponder()
    }
    
    @objc private func tapDefaultNameBarButton() {
        defaultNameBarButtonDidTap.accept(())
        resignFirstResponder()
    }
}

// MARK: - UI Configuration

private extension NameTextField {
    func configureUI() {
        layer.borderWidth = 1
        layer.cornerRadius = 8
        layer.borderColor = UIColor.systemGray.cgColor
        clearButtonMode = .whileEditing
        autocapitalizationType = .none
        spellCheckingType = .no
        smartDashesType = .no
        autocorrectionType = .no
        addLeftPadding(inset: 12)
    }
}
