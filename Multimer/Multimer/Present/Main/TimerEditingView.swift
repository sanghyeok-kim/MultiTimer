//
//  TimerEditingView.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/13.
//

import RxSwift
import RxRelay

final class TimerEditingView: UIView {
    
    let buttonInEditViewDidTap = PublishRelay<EditViewButtonType>()
    let deleteButtonDidTap = PublishRelay<Void>()
    let enableButtons = BehaviorRelay<Bool>(value: false)
    
    private lazy var startButton: SymobolImageButton = {
        let button = SymobolImageButton(size: 24, systemName: "play.fill", color: .systemTeal)
        button.rx.tap
            .map { .start }
            .bind(to: buttonInEditViewDidTap)
            .disposed(by: disposeBag)
        return button
    }()
    
    private lazy var pauseButton: SymobolImageButton = {
        let button = SymobolImageButton(size: 24, systemName: "pause.fill", color: .systemBlue)
        button.rx.tap
            .map { .pause }
            .bind(to: buttonInEditViewDidTap)
            .disposed(by: disposeBag)
        return button
    }()
    
    private lazy var resetButton: SymobolImageButton = {
        let button = SymobolImageButton(size: 24, systemName: "stop.fill", color: .magenta)
        button.rx.tap
            .map { .reset }
            .bind(to: buttonInEditViewDidTap)
            .disposed(by: disposeBag)
        return button
    }()
    
    private lazy var deleteButton: SymobolImageButton = {
        let button = SymobolImageButton(size: 24, systemName: "trash.fill", color: .systemRed)
        button.rx.tap
            .bind(to: deleteButtonDidTap)
            .disposed(by: disposeBag)
        return button
    }()
    
    private lazy var timerEditingButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [startButton, pauseButton, resetButton, deleteButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        layout()
        
        enableButtons
            .bind(to: startButton.rx.isEnabled, pauseButton.rx.isEnabled, resetButton.rx.isEnabled, deleteButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TimerEditingView {
    func configureUI() {
        backgroundColor = .systemGray5
    }
    
    func layout() {
        addSubview(timerEditingButtonStackView)
        
        timerEditingButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        timerEditingButtonStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        timerEditingButtonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 42).isActive = true
        timerEditingButtonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -42).isActive = true
    }
}
