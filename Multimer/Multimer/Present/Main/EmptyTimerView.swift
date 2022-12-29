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
        switch timerFilteringCondition {
        case .all:
            emptyTimerLabel.text = "생성된 타이머 없음"
            addTimerLabel.text = "+ 버튼을 눌러 새로운 타이머를 추가하세요."
        case .active:
            emptyTimerLabel.text = "활성화된 타이머 없음"
            addTimerLabel.text = "실행 또는 일시정지 상태의 타이머만 나타납니다."
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


