//
//  NameTextField.swift
//  Multimer
//
//  Created by 김상혁 on 2023/02/08.
//

import UIKit

final class NameTextField: UITextField {
    
    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.backgroundColor = .systemBackground
        
        let doneBarButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: nil,
            action: #selector(doneBarButtonDidTap)
        )
        
        let flexibleSpaceButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        toolbar.sizeToFit()
        toolbar.setItems([flexibleSpaceButton, doneBarButton], animated: false)
        return toolbar
    }()
    
    init() {
        super.init(frame: .zero)
        configureUI()
        inputAccessoryView = toolbar
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func doneBarButtonDidTap() {
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
