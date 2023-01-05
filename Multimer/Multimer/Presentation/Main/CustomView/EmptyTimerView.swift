//
//  EmptyTimerView.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/29.
//

import UIKit

final class EmptyTimerView: UIView {
    
    private lazy var emptyTimerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private lazy var addTimerLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emptyTimerLabel, addTimerLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    
    init(timerFilteringCondition: TimerFilteringCondition) {
        super.init(frame: .zero)
        configure(with: timerFilteringCondition)
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Configuration

private extension EmptyTimerView {
    func configure(with timerFilteringCondition: TimerFilteringCondition) {
        let noTimerCreatedMessageString = LocalizableString.noTimerCreatedMessage.localized
        let addTimerMessage = LocalizableString.addTimerMessage.localized
        let noTimerActivatedMessage = LocalizableString.noTimerActivatedMessage.localized
        let onlyActiveTimersAppearMessage = LocalizableString.onlyActiveTimersAppearMessage.localized
        
        switch timerFilteringCondition {
        case .all:
            emptyTimerLabel.text = noTimerCreatedMessageString
            addTimerLabel.text = addTimerMessage
        case .active:
            emptyTimerLabel.text = noTimerActivatedMessage
            addTimerLabel.text = onlyActiveTimersAppearMessage
        }
    }
}

// MARK: - UI Layout

private extension EmptyTimerView {
    func layout() {
        addSubview(labelStackView)
        
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        labelStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -48).isActive = true
    }
}


