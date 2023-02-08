//
//  TimerCreateViewController.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/21.
//

import RxSwift
import RxRelay
import RxAppState

final class TimerCreateViewController: UIViewController, ViewType {
    
    private lazy var timerTypeSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: [TimerType.countDown.name, TimerType.countUp.name])
        segmentControl.selectedSegmentIndex = TimerType.countDown.index
        return segmentControl
    }()
    
    private lazy var tagScrollView: TagScrollView = {
        let scrollView = TagScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.borderWidth = 1
        scrollView.layer.cornerRadius = 8
        scrollView.layer.borderColor = UIColor.systemGray.cgColor
        return scrollView
    }()
    
    private lazy var nameTextField: NameTextField = {
        let nameTextField = NameTextField()
        nameTextField.becomeFirstResponder()
        return nameTextField
    }()
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
        textField.becomeFirstResponder()
        return textField
    }()
    
    private lazy var completeButton: PaddingButton = {
        let button = PaddingButton(padding: UIEdgeInsets(top: 10, left: .zero, bottom: 10, right: .zero))
        button.isEnabled = false
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.setTitle(LocalizableString.done.localized, for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.setTitleColor(UIColor.systemGray3, for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: ViewSize.buttonFont, weight: .semibold)
        return button
    }()
    
    private lazy var cancelButton: PaddingButton = {
        let button = PaddingButton(padding: UIEdgeInsets(top: 10, left: .zero, bottom: 10, right: .zero))
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.setTitle(LocalizableString.cancel.localized, for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: ViewSize.buttonFont)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, completeButton])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var timePickerButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timePickerView, buttonStackView])
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
    
    private let disposeBag = DisposeBag()
    var viewModel: TimerCreateViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func bindInput(to viewModel: TimerCreateViewModel) {
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
        
        nameTextField.rx.controlEvent(.editingDidEndOnExit)
            .withUnretained(self)
            .bind { `self`, _ in
                self.nameTextField.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        
        timePickerView.rx.itemSelected
            .withUnretained(self)
            .map { `self`, _ -> Time in
                return self.timePickerView.configureTime()
            }
            .bind(to: input.timePickerViewDidEdit)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(from viewModel: TimerCreateViewModel) {
        let output = viewModel.output
        
        output.exitScene
            .withUnretained(self)
            .bind { `self`, _ in
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.completeButtonEnable
            .bind(to: completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.timePickerViewIsHidden
            .bind(to: timePickerView.rx.animated.flip(.top, duration: 0.35).isHidden)
            .disposed(by: disposeBag)
        
        output.placeholder
            .bind(to: nameTextField.rx.placeholder)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Configuration

private extension TimerCreateViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - UI Layout

private extension TimerCreateViewController {
    func layout() {
        view.addSubview(timerTypeSegmentControl)
        view.addSubview(tagScrollView)
        view.addSubview(nameTextField)
        view.addSubview(timePickerButtonStackView)
        
        timerTypeSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        timerTypeSegmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        timerTypeSegmentControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 48).isActive = true
        timerTypeSegmentControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -48).isActive = true
        timerTypeSegmentControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollView.topAnchor.constraint(equalTo: timerTypeSegmentControl.bottomAnchor, constant: 20).isActive = true
        tagScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36).isActive = true
        tagScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36).isActive = true
        tagScrollView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.12).isActive = true
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.topAnchor.constraint(equalTo: tagScrollView.bottomAnchor, constant: 20).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.12).isActive = true
        
        timePickerButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        timePickerButtonStackView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        timePickerButtonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36).isActive = true
        timePickerButtonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36).isActive = true
    }
}

// MARK: - Name Space

private extension TimerCreateViewController {
    enum ViewSize {
        static let buttonFont = 18.0
    }
}
