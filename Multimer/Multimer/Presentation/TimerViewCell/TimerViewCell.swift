//
//  TimerViewCell.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import RxSwift
import RxCocoa
import RxAnimated

final class TimerViewCell: UITableViewCell, CellIdentifiable, ViewType {
    
    private let cellTapButton = UIButton()
    private let timerTypeSymbolImageView = UIImageView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: ViewSize.titleLabelFont)
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let titleStackView = UIStackView()
        titleStackView.axis = .horizontal
        titleStackView.spacing = 2
        titleStackView.distribution = .equalCentering
        titleStackView.alignment = .firstBaseline
        titleStackView.addArrangedSubviews([timerTypeSymbolImageView, titleLabel])
        timerTypeSymbolImageView.setContentCompressionResistancePriority(.init(751), for: .horizontal)
        return titleStackView
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: ViewSize.timeLabelFont, weight: .medium)
        return label
    }()
    
    private lazy var initialTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: ViewSize.initialTimeLabel)
        label.alpha = 0.65
        label.isHidden = true
        return label
    }()
    
    private lazy var timerStackView: UIStackView = {
        let timerStackView = UIStackView(arrangedSubviews: [titleStackView, timeLabel, initialTimeLabel])
        timerStackView.axis = .vertical
        timerStackView.spacing = .zero
        timerStackView.distribution = .equalSpacing
        timerStackView.alignment = .leading
        return timerStackView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.isUserInteractionEnabled = false
        progressView.progressViewStyle = .bar
        progressView.progressTintColor = CustomColor.ProgressView.progressTint
        progressView.trackTintColor = CustomColor.ProgressView.trackTint
        return progressView
    }()
    
    private lazy var toggleButton: UIButton = {
        let button = UIButton()
        applyImpactFeedbackGenerator(to: button)
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        let resetImageColor = CustomColor.Button.resetImage
        let resetImage = UIImage.makeSFSymbolImage(
            size: ViewSize.buttonImage,
            systemName: Constant.SFSymbolName.checkmarkCircle,
            color: resetImageColor
        )
        button.setImage(resetImage, for: .normal)
        applyImpactFeedbackGenerator(to: button)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [toggleButton, resetButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private var impactFeedbackGenerator: UIImpactFeedbackGenerator? = .init(style: .medium)
    private var disposeBag = DisposeBag()
    var viewModel: TimerCellViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareFeedbackImpactGenerator()
        configureUI()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        initialTimeLabel.isHidden = true
        progressView.progress = .zero
        disposeBag = DisposeBag()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        viewModel?.input.cellDidSelect.accept(selected)
    }
    
    func bindInput(to viewModel: TimerCellViewModel) {
        let input = viewModel.input
        
        cellTapButton.rx.tap
            .bind(to: input.cellDidTap)
            .disposed(by: disposeBag)
        
        toggleButton.rx.tap
            .bind(to: input.toggleButtonDidTap)
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .bind(to: input.resetButtonDidTap)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(from viewModel: TimerCellViewModel) {
        let output = viewModel.output
        
        output.timer
            .withUnretained(self)
            .bind { `self`, timer in
                self.configureUI(with: timer)
            }
            .disposed(by: disposeBag)
        
        output.timer
            .map { $0.time.formattedTotalSeconds }
            .bind(to: initialTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.initialTimeLabelIsHidden
            .bind(to: initialTimeLabel.rx.animated.fade(duration: 0.3).isHidden)
            .disposed(by: disposeBag)
        
        output.toggleButtonIsSelected
            .bind(to: toggleButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.toggleButtonIsHidden
            .bind(to: toggleButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.resetButtonIsHidden
            .bind(to: resetButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.progessRatio
            .withUnretained(self)
            .bind { `self`, ratio in
                self.progressView.setProgress(ratio, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.cellCanTap
            .bind(to: cellTapButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    deinit {
        impactFeedbackGenerator = nil
    }
}

// MARK: - Feedback Generators

private extension TimerViewCell {
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

// MARK: - UI Configuration

private extension TimerViewCell {
    func configureUI() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 15
        backgroundColor = .systemBackground
        configureSelectedBackgroundView()
    }
    
    func configureSelectedBackgroundView() {
        let backgroundView = UIView()
        selectedBackgroundView = backgroundView
    }
    
    func configureUI(with timer: Timer) {
        titleLabel.text = timer.name
        timeLabel.text = timer.time.formattedRemainingSeconds
        configureToggleButton(by: timer)
        configureTimerTypeSymbolImageView(by: timer)
    }
    
    func configureTimerTypeSymbolImageView(by timer: Timer) {
        switch timer.type {
        case .countDown:
            timerTypeSymbolImageView.image = UIImage.makeSFSymbolImage(
                size: ViewSize.timerTypeSymbolImage,
                systemName: Constant.SFSymbolName.hourglassTophalfFilled,
                color: TagColorFactory.generateUIColor(of: timer.tag?.color)
            )
        case .countUp:
            timerTypeSymbolImageView.image = UIImage.makeSFSymbolImage(
                size: ViewSize.timerTypeSymbolImage,
                systemName: Constant.SFSymbolName.stopwatchFill,
                color: TagColorFactory.generateUIColor(of: timer.tag?.color)
            )
        }
    }
    
    func configureToggleButton(by timer: Timer) {
        let startImageDynamicColor = CustomColor.Button.startImage
        let pauseImageDynamicColor = CustomColor.Button.pauseImage
        switch timer.type {
        case .countDown:
            let playImage = UIImage.makeSFSymbolImage(
                size: ViewSize.buttonImage,
                systemName: Constant.SFSymbolName.playCircle,
                color: startImageDynamicColor
            )
            let pauseImage = UIImage.makeSFSymbolImage(
                size: ViewSize.buttonImage,
                systemName: Constant.SFSymbolName.pauseCircle,
                color: pauseImageDynamicColor
            )
            toggleButton.setImage(playImage, for: .normal)
            toggleButton.setImage(pauseImage, for: .selected)
        case .countUp:
            let playImage = UIImage.makeSFSymbolImage(
                size: ViewSize.buttonImage,
                systemName: Constant.SFSymbolName.playCircleFill,
                color: startImageDynamicColor
            )
            let pauseImage = UIImage.makeSFSymbolImage(
                size: ViewSize.buttonImage,
                systemName: Constant.SFSymbolName.pauseCircleFill,
                color: pauseImageDynamicColor
            )
            toggleButton.setImage(playImage, for: .normal)
            toggleButton.setImage(pauseImage, for: .selected)
        }
    }
}

// MARK: - UI Layout

private extension TimerViewCell {
    func layout() {
        contentView.addSubview(progressView)
        contentView.addSubview(timerStackView)
        contentView.addSubview(cellTapButton)
        contentView.addSubview(buttonStackView)
        
        cellTapButton.translatesAutoresizingMaskIntoConstraints = false
        cellTapButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellTapButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        cellTapButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellTapButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        timerStackView.translatesAutoresizingMaskIntoConstraints = false
        timerStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        timerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        timerStackView.trailingAnchor.constraint(equalTo: buttonStackView.leadingAnchor).isActive = true
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        progressView.transform = progressView.transform.scaledBy(x: 1, y: -100)
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        buttonStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}

// MARK: - Name Space

private extension TimerViewCell {
    enum ViewSize {
        static let titleLabelFont: CGFloat = 17.0
        static let timeLabelFont: CGFloat = 32.0
        static let initialTimeLabel: CGFloat = 18.0
        static let buttonImage: CGFloat = 50.0
        static let timerTypeSymbolImage: CGFloat = 17.0
    }
}
