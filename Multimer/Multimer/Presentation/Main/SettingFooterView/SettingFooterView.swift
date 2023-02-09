//
//  SettingFooterView.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/14.
//

import RxSwift
import RxRelay

final class SettingFooterView: UITableViewHeaderFooterView, CellIdentifiable {
    
    private lazy var purchaseLabel: UILabel = {
        let label = UILabel()
        label.text = "프리미엄 결제하고 광고 제거하기"
        return label
    }()
    
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18)
        
        let settingImage = UIImage(
            systemName: "gearshape.fill",
            withConfiguration: imageConfig
        )?.withTintColor(.gray , renderingMode: .alwaysOriginal)
        
        button.setImage(settingImage, for: .normal)
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SettingFooterView {
    func layout() {
        addSubview(purchaseLabel)
        addSubview(settingButton)
        
        purchaseLabel.translatesAutoresizingMaskIntoConstraints = false
        purchaseLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        purchaseLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        settingButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        settingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true
    }
}
