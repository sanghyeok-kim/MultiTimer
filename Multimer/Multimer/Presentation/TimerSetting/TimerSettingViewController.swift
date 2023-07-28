//
//  TimerSettingViewController.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/02.
//

import ReactorKit
import RxAppState

final class TimerSettingViewController: UIViewController, View {
    
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
    
    private lazy var nameTextField = NameTextField(toolbarType: .setting)
    
    private lazy var completeButton: PaddingButton = {
        let button = PaddingButton(padding: UIEdgeInsets(top: 10, left: .zero, bottom: 10, right: .zero))
        button.isEnabled = false
        button.layer.borderWidth = 0.5
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
        button.layer.borderWidth = 0.5
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
        stackView.spacing = 36
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
    
    func bind(reactor: TimerSettingViewModel) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
}

// MARK: - Bind Reactor

private extension TimerSettingViewController {
    func bindAction(reactor: TimerSettingViewModel) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tagScrollView.rx.tagDidSelect
            .map { Reactor.Action.tagDidSelect($0) }
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
        
        cancelButton.rx.tap
            .map { Reactor.Action.cancelButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .map { Reactor.Action.completeButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        timePickerView.rx.itemSelected
            .withUnretained(self)
            .map { `self`, _ -> Time in
                return self.timePickerView.configureTime()
            }
            .map { Reactor.Action.timePickerViewDidEdit($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: TimerSettingViewModel) {
        reactor.state.map { $0.initialTimer }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { `self`, timer in
                self.configureUI(with: timer)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.editedTimer.tag }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(to: tagScrollView.rx.selectTag)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isCompleteButtonEnable }
            .distinctUntilChanged()
            .bind(to: completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isTimePickerViewHidden }
            .distinctUntilChanged()
            .bind(to: timePickerView.rx.isHidden)
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
    }
}

// MARK: - UI Layout

private extension TimerSettingViewController {
    func layout() {
        view.addSubview(tagScrollView)
        view.addSubview(nameTextField)
        view.addSubview(timePickerView)
        view.addSubview(timePickerButtonStackView)
        
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
        
        timePickerButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        timePickerButtonStackView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        timePickerButtonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 36).isActive = true
        timePickerButtonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -36).isActive = true
    }
}

// MARK: - Name Space

private extension TimerSettingViewController {
    enum ViewSize {
        static let buttonFont = 18.0
    }
}
