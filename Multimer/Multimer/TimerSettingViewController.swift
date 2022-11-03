//
//  TimerSettingViewController.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/02.
//

import UIKit

final class TimerSettingViewController: UIViewController {
    private lazy var timePickerViewDataSource = TimePickerViewDataSource()
    private lazy var tiemPickerViewDelegate = TimePickerViewDelegate()
    private lazy var timePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = timePickerViewDataSource
        pickerView.delegate = tiemPickerViewDelegate
        pickerView.backgroundColor = .systemGray2
        pickerView.setFixedLabels(with: TimeType.allCases.map { $0.title })
        
        return pickerView
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            let hour = self?.timePickerView.selectedRow(inComponent: 0)
            let minute = self?.timePickerView.selectedRow(inComponent: 1)
            let seconds = self?.timePickerView.selectedRow(inComponent: 2)
            
            // FIXME: 삭제
            print(hour)
            print(minute)
            print(seconds)
            
        }), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        layout()
    }
}

// MARK: - View Layout

private extension TimerSettingViewController {
    func layout() {
        view.addSubview(timePickerView)
        view.addSubview(startButton)
        
        timePickerView.translatesAutoresizingMaskIntoConstraints = false
        timePickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timePickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.topAnchor.constraint(equalTo: timePickerView.bottomAnchor, constant: 40).isActive = true
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

