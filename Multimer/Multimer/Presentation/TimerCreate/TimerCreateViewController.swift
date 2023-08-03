//
//  TimerCreateViewController.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/21.
//

import ReactorKit
import RxAnimated

final class TimerCreateViewController: UIViewController, View {
    
    private lazy var timerTypeSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: [
            TimerType.countDown.name,
            TimerType.countUp.name
        ])
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
        let nameTextField = NameTextField(toolbarType: .create)
        nameTextField.becomeFirstResponder()
        return nameTextField
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
    
    private lazy var timePickerViewDataSource = TimePickerViewDataSource()
    private lazy var tiemPickerViewDelegate = TimePickerViewDelegate()
    private lazy var timePickerView: TimePickerView = {
        let pickerView = TimePickerView()
        pickerView.dataSource = timePickerViewDataSource
        pickerView.delegate = tiemPickerViewDelegate
        return pickerView
    }()
    
    private lazy var timePickerButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timePickerView, buttonStackView])
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
    
    var disposeBag = DisposeBag()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layout()
    }
    
    func bind(reactor: TimerCreateReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
}

// MARK: - Bind Reactor

private extension TimerCreateViewController {
    func bindAction(reactor: TimerCreateReactor) {
        timerTypeSegmentControl.rx.selectedSegmentIndex
            .compactMap { TimerType(rawValue: $0) }
            .map { Reactor.Action.timerTypeDidSelect($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tagScrollView.rx.tagDidSelect
            .map { Reactor.Action.tagDidSelect($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nameTextField.defaultNameBarButton.rx.tap
            .map { Reactor.Action.defaultNameBarButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .map { Reactor.Action.cancelButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .map { Reactor.Action.completeButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nameTextField.rx.textChanged
            .map { Reactor.Action.nameTextFieldDidEdit($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nameTextField.rx.controlEvent(.editingDidEndOnExit)
            .withUnretained(self)
            .bind { `self`, _ in
                self.nameTextField.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        
        timePickerView.rx.itemSelected
            .compactMap { [weak self] _ in
                self?.timePickerView.configureTime()
            }
            .map { Reactor.Action.timePickerViewDidEdit($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: TimerCreateReactor) {
        reactor.state.map { $0.isCompleteButtonEnabled }
            .distinctUntilChanged()
            .bind(to: completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.timer.name }
            .distinctUntilChanged()
            .bind(to: nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.timer.tag }
            .compactMap { $0 }
            .distinctUntilChanged()
            .bind(to: tagScrollView.rx.selectTag)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.timerNamePlaceholder }
            .distinctUntilChanged()
            .bind(to: nameTextField.rx.placeholder)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isTimePickerViewHidden }
            .distinctUntilChanged()
            .bind(to: timePickerView.rx.animated.flip(.top, duration: 0.35).isHidden)
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
