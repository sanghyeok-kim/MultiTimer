//
//  TimerSettingViewController.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/02.
//

import RxSwift
import RxRelay
import RxAppState

extension UITextField {
  func addLeftPadding(inset: Double) {
      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: inset, height: self.frame.height))
      leftViewMode = .always
      leftView = paddingView
  }
}

extension UIPickerView { //TimerPickerView로 한정시키기
    func selectRows(by time: Time, animated: Bool) {
        let (hour, minute, second) = time.dividedSeconds
        selectRow(hour, inComponent: 0, animated: true) // TODO: 하드코딩 개선
        selectRow(minute, inComponent: 1, animated: true)
        selectRow(second, inComponent: 2, animated: true)
    }
}

final class TimerSettingViewController: UIViewController, ViewType {
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
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray5
        textField.clearButtonMode = .whileEditing
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        textField.smartDashesType = .no
        textField.autocorrectionType = .no
        textField.addLeftPadding(inset: 8)
        return textField
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        return button
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        nameTextField.rx.controlEvent(.editingDidEndOnExit)
            .withUnretained(self)
            .bind { `self`, _ in
                self.nameTextField.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        
        layout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func bind(to viewModel: TimerSettingViewModel) {
        bindInput(to: viewModel)
        bindOutput(from: viewModel)
    }
    
    private func bindInput(to viewModel: TimerSettingViewModel) {
        // 초기 이벤트 하나는 발생시켜야하므로 PublishRelay가 아닌 BehaviorRelay 사용
        // (초기 이벤트 하나를 발생시켜야 하는 이유 -> VM에서 CombineLatest로 받으므로, 모든 이벤트가 Combine되지 않으면 tap 이벤트가 호출되지 않음)
//        let timePickerViewDidEit = BehaviorRelay<(hour: Int, minute: Int, second: Int)>(value: (0, 0, 0))
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .bind(to: input.completeButtonDidTap)
            .disposed(by: disposeBag)
        
        nameTextField.rx.textChanged.skip(1)
            .bind(to: input.nameTextFieldDidEdit)
            .disposed(by: disposeBag)
        
        timePickerView.rx.itemSelected
            .withUnretained(self)
            .map { `self`, _ -> (Int, Int, Int) in
                let hour = self.timePickerView.selectedRow(inComponent: 0) // TODO: 하드코딩 개선, Simplify
                let minute = self.timePickerView.selectedRow(inComponent: 1)
                let second = self.timePickerView.selectedRow(inComponent: 2)
                return (hour, minute, second)
            }
            .bind(to: input.timePickerViewDidEdit)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(from viewModel: TimerSettingViewModel) {
        let output = viewModel.output
        
        output.timer
            .withUnretained(self)
            .bind { `self`, timer in // TODO: 속성 더 추가
                self.nameTextField.placeholder = timer.name
                self.nameTextField.text = timer.name
                self.timePickerView.selectRows(by: timer.time, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.newTimer
            .withUnretained(self)
            .bind { `self`, _ in
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - View Layout

private extension TimerSettingViewController {
    func layout() {
        view.addSubview(nameTextField)
        view.addSubview(timePickerView)
        view.addSubview(completeButton)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.bottomAnchor.constraint(equalTo: timePickerView.topAnchor, constant: -16).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 32).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: timePickerView.leadingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: timePickerView.trailingAnchor).isActive = true
        
        timePickerView.translatesAutoresizingMaskIntoConstraints = false
        timePickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timePickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.topAnchor.constraint(equalTo: timePickerView.bottomAnchor, constant: 40).isActive = true
        completeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

