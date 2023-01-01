//
//  TimerSettingViewController.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/02.
//

import RxSwift
import RxRelay
import RxAppState

final class TimerSettingViewController: UIViewController, ViewType {
    
    private lazy var timePickerViewDataSource = TimePickerViewDataSource()
    private lazy var tiemPickerViewDelegate = TimePickerViewDelegate()
    private lazy var timePickerView: TimePickerView = {
        let pickerView = TimePickerView()
        pickerView.dataSource = timePickerViewDataSource
        pickerView.delegate = tiemPickerViewDelegate
        return pickerView
    }()
    
    private lazy var tagScrollView: TagScrollView = {
        let scrollView = TagScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.borderWidth = 0.5
        scrollView.layer.cornerRadius = 8
        scrollView.layer.borderColor = UIColor.systemGray.cgColor
        return scrollView
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.clearButtonMode = .whileEditing
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        textField.smartDashesType = .no
        textField.autocorrectionType = .no
        textField.addLeftPadding(inset: 12)
        return textField
    }()
    
    private lazy var completeButton: PaddingButton = {
        let button = PaddingButton(padding: UIEdgeInsets(top: 10, left: .zero, bottom: 10, right: .zero))
        button.isEnabled = false
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.setTitle(LocalizableString.done.localized, for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.setTitleColor(UIColor.systemGray3, for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return button
    }()
    
    private lazy var cancelButton: PaddingButton = {
        let button = PaddingButton(padding: UIEdgeInsets(top: 10, left: .zero, bottom: 10, right: .zero))
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.setTitle(LocalizableString.cancel.localized, for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        //제공 해줌
        let stackView = UIStackView(arrangedSubviews: [cancelButton, completeButton])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var timeSettingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timePickerView, buttonStackView])
        stackView.axis = .vertical
        stackView.spacing = 36
        
        return stackView
    }()
    
    private let disposeBag = DisposeBag()
    var viewModel: TimerSettingViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
        
        nameTextField.rx.controlEvent(.editingDidEndOnExit)
            .withUnretained(self)
            .bind { `self`, _ in
                self.nameTextField.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        
        timePickerView.rx.itemSelected
            .withUnretained(self)
            .map { `self`, _ -> Time in
                let hour = self.timePickerView.selectedRow(inComponent: 0) // TODO: 하드코딩 개선, Simplify
                let minute = self.timePickerView.selectedRow(inComponent: 1)
                let second = self.timePickerView.selectedRow(inComponent: 2)
                return Time(hour: hour, minute: minute, second: second)
            }
            .bind(to: input.timePickerViewDidEdit)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(from viewModel: TimerSettingViewModel) {
        let output = viewModel.output
        
            }
            .disposed(by: disposeBag)
        
        output.timer
            .withUnretained(self)
            .bind { `self`, timer in
                self.configureUI(with: timer)
            }
            .disposed(by: disposeBag)
        
        // TODO: Coordinator로 제어
        output.exitScene
            .withUnretained(self)
            .bind { `self`, _ in
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

// MARK: - UI Configuration

private extension TimerSettingViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    func configureUI(with timer: Timer) {
        title = LocalizableString.settingTimer(timerType: timer.type).localized
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
        
        view.addSubview(timeSettingStackView)
        
        
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48).isActive = true
        tagScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 36).isActive = true
        tagScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -36).isActive = true
        tagScrollView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.12).isActive = true
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.topAnchor.constraint(equalTo: tagScrollView.bottomAnchor, constant: 20).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.12).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor).isActive = true
        
        timeSettingStackView.translatesAutoresizingMaskIntoConstraints = false
        timeSettingStackView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        timeSettingStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 36).isActive = true
        timeSettingStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -36).isActive = true
    }
}

