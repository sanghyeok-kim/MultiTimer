//
//  TimePickerView.swift
//  Multimer
//
//  Created by 김상혁 on 2023/01/02.
//

import UIKit

final class TimePickerView: UIPickerView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Providing Methods

extension TimePickerView {
    func selectRows(by time: Time, animated: Bool) {
        let (hour, minute, second) = time.dividedTotalSeconds
        selectRow(hour, inComponent: 0, animated: true)
        selectRow(minute, inComponent: 1, animated: true)
        selectRow(second, inComponent: 2, animated: true)
    }
    
    func configureTime() -> Time {
        let hour = selectedRow(inComponent: 0)
        let minute = selectedRow(inComponent: 1)
        let second = selectedRow(inComponent: 2)
        return Time(hour: hour, minute: minute, second: second)
    }
}

// MARK: - UI Configuration

private extension TimePickerView {
    func configureUI() {
        layer.borderWidth = 0.5
        layer.cornerRadius = 8
        layer.borderColor = UIColor.systemGray.cgColor
        setFixedLabels(with: TimeType.allCases.map { $0.title })
    }
}

