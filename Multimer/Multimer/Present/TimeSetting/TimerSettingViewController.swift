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
        let (hour, minute, second) = time.dividedTotalSeconds
        selectRow(hour, inComponent: 0, animated: true) // TODO: 하드코딩 개선
        selectRow(minute, inComponent: 1, animated: true)
        selectRow(second, inComponent: 2, animated: true)
    }
}

final class TimerSettingViewController: UIViewController, ViewType {
    
    private lazy var timerTypeSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: [TimerType.countDown.title, TimerType.countUp.title])
        segmentControl.selectedSegmentIndex = TimerType.countDown.index
        return segmentControl
    }()
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
    
    private lazy var tagScrollView: TagScrollView = {
        let scrollView = TagScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .systemGray6
        return scrollView
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
        button.isEnabled = false
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.setTitleColor(UIColor.systemGray2, for: .disabled)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        //제공 해줌
        let stackView = UIStackView(arrangedSubviews: [cancelButton, completeButton])
        stackView.axis = .horizontal
        stackView.spacing = 88
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let disposeBag = DisposeBag()
    var viewModel: TimerSettingViewModel?
    
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
    
    func bindInput(to viewModel: TimerSettingViewModel) {
        // 초기 이벤트 하나는 발생시켜야하므로 PublishRelay가 아닌 BehaviorRelay 사용
        // (초기 이벤트 하나를 발생시켜야 하는 이유 -> VM에서 CombineLatest로 받으므로, 모든 이벤트가 Combine되지 않으면 tap 이벤트가 호출되지 않음)
//        let timePickerViewDidEit = BehaviorRelay<(hour: Int, minute: Int, second: Int)>(value: (0, 0, 0))
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        timerTypeSegmentControl.rx.selectedSegmentIndex
            .compactMap { TimerType(rawValue: $0) }
            .bind(to: input.selectedTimerType)
            .disposed(by: disposeBag)
        
        tagScrollView.tagDidSelect
            .bind(to: input.tagDidSelect)
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .bind(to: input.cancelButtonDidTap)
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .bind(to: input.completeButtonDidTap)
            .disposed(by: disposeBag)
        
        nameTextField.rx.textChanged
            .orEmpty
            .skip(1)
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
    
    func bindOutput(from viewModel: TimerSettingViewModel) {
        let output = viewModel.output
        
        output.timer
            .withUnretained(self)
            .bind { `self`, timer in
                self.configureUI(with: timer)
            }
            .disposed(by: disposeBag)
        
        // TODO: Coordinator로 제어
        output.newTimer
            .withUnretained(self)
            .bind { `self`, _ in
                self.dismiss(animated: true)
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        // TODO: Coordinator로 제어
        output.timerSettingCancel
            .withUnretained(self)
            .bind { `self`, _ in
                self.dismiss(animated: true)
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.completeButtonEnable
            .bind(to: completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.timePickerViewIsHidden
            .bind(to: timePickerView.rx.animated.flip(.top, duration: 0.35).isHidden)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Confiurating

private extension TimerSettingViewController {
    func configureUI(with timer: Timer) {
        nameTextField.placeholder = timer.name
        nameTextField.text = timer.name
        timePickerView.selectRows(by: timer.time, animated: true)
        tagScrollView.tagDidSelect.accept(timer.tag)
    }
}

// MARK: - UI Layout

private extension TimerSettingViewController {
    func layout() {
        view.addSubview(tagScrollView)
        view.addSubview(nameTextField)
        view.addSubview(timePickerView)
        view.addSubview(buttonStackView)
        
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollView.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -20).isActive = true
        tagScrollView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor).isActive = true
        tagScrollView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor).isActive = true
        tagScrollView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.12).isActive = true
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.bottomAnchor.constraint(equalTo: timePickerView.topAnchor, constant: -16).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.12).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: timePickerView.leadingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: timePickerView.trailingAnchor).isActive = true
        
        timePickerView.translatesAutoresizingMaskIntoConstraints = false
        timePickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timePickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.topAnchor.constraint(equalTo: timePickerView.bottomAnchor, constant: 40).isActive = true
        buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

