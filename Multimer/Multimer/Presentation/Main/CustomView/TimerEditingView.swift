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
    
    private lazy var startButton: SymbolImageButton = {
        let button = SymbolImageButton(
            size: ViewSize.symbolImageButton,
            systemName: Constant.SFSymbolName.playFill,
            color: CustomColor.Button.startImage
        )
        button.rx.tap
            .map { .start }
            .bind(to: buttonInEditViewDidTap)
            .disposed(by: disposeBag)
        applyImpactFeedbackGenerator(to: button)
        return button
    }()
    
    private lazy var pauseButton: SymbolImageButton = {
        let button = SymbolImageButton(
            size: ViewSize.symbolImageButton,
            systemName: Constant.SFSymbolName.pauseFill,
            color: CustomColor.Button.pauseImage
        )
        button.rx.tap
            .map { .pause }
            .bind(to: buttonInEditViewDidTap)
            .disposed(by: disposeBag)
        applyImpactFeedbackGenerator(to: button)
        return button
    }()
    
    private lazy var resetButton: SymbolImageButton = {
        let button = SymbolImageButton(
            size: ViewSize.symbolImageButton,
            systemName: Constant.SFSymbolName.stopFill,
            color: CustomColor.Button.resetImage
        )
        button.rx.tap
            .map { .reset }
            .bind(to: buttonInEditViewDidTap)
            .disposed(by: disposeBag)
        applyImpactFeedbackGenerator(to: button)
        return button
    }()
    
    private lazy var deleteButton: SymbolImageButton = {
        let button = SymbolImageButton(size: ViewSize.symbolImageButton, systemName: Constant.SFSymbolName.trashFill, color: CustomColor.Button.deleteImage)
        button.rx.tap
            .bind(to: deleteButtonDidTap)
            .disposed(by: disposeBag)
        applyImpactFeedbackGenerator(to: button)
        return button
    }()
    
    private lazy var timerEditingButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [startButton, pauseButton, resetButton, deleteButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private var impactFeedbackGenerator: UIImpactFeedbackGenerator? = .init(style: .medium)
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
    
    deinit {
        impactFeedbackGenerator = nil
    }
}

private extension TimerEditingView {
    func configureUI() {
        backgroundColor = CustomColor.View.timerEditing
    }
    
    func layout() {
        addSubview(timerEditingButtonStackView)
        
        timerEditingButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        timerEditingButtonStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        timerEditingButtonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 42).isActive = true
        timerEditingButtonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -42).isActive = true
    }
}

// MARK: - Name Space

private extension TimerEditingView {
    enum ViewSize {
        static let symbolImageButton: CGFloat = 24.0
    }
}

// MARK: - Feedback Generators

private extension TimerEditingView {
    func prepareFeedbackImpactGenerator() {
        impactFeedbackGenerator = UIImpactFeedbackGenerator()
        impactFeedbackGenerator?.prepare()
    }
    
    func applyImpactFeedbackGenerator(to button: UIButton) {
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.impactFeedbackGenerator?.impactOccurred()
        }), for: .touchUpInside)
    }
}
