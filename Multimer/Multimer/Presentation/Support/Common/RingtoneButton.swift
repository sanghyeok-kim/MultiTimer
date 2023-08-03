//
//  RingtoneButton.swift
//  Multimer
//
//  Created by 김상혁 on 2023/08/02.
//

import UIKit

final class RingtoneButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - UI Configuration

private extension RingtoneButton {
    func configureUI() {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: Constant.SFSymbolName.bellFill)
        configuration.imagePadding = 8
        configuration.imagePlacement = .leading
        configuration.titleAlignment = .trailing
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: .zero, bottom: 12, trailing: .zero)
        self.configuration = configuration
        tintColor = .label
        layer.borderWidth = 1
        layer.cornerRadius = 8
        layer.borderColor = UIColor.systemGray.cgColor
    }
}
