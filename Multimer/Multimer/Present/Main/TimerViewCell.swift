//
//  TimerViewCell.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import RxSwift
import RxCocoa
import RxAnimated

final class TagLabel: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.frame.size = CGSize(width: 18, height: 18)
        layer.cornerRadius = 9
    }
}


final class TimerViewCell: UITableViewCell, CellIdentifiable, ViewType {
    
    private let cellTapButton = UIButton()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .systemGreen // FIXME: 삭제
        return label
    }()
    
    private lazy var tagLabel: TagLabel = {
        let label = TagLabel()
        return label
    }()
    
//    private lazy var tagLabel = TagLabel()
    
    private lazy var titleStackView: UIStackView = {
        let titleStackView = UIStackView()
        titleStackView.axis = .horizontal
        titleStackView.spacing = 2
        titleStackView.distribution = .equalSpacing
        titleStackView.addArrangedSubviews([titleLabel, tagLabel])
        return titleStackView
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        return label
    }()
    
    private lazy var initialTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .systemGray
        label.isHidden = true
        return label
    }()
    
    private lazy var timerStackView: UIStackView = {
        let timerStackView = UIStackView(arrangedSubviews: [titleStackView, timeLabel])
        timerStackView.axis = .vertical
        timerStackView.spacing = 2
        timerStackView.distribution = .equalSpacing
        timerStackView.alignment = .leading
        return timerStackView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressViewStyle = .bar
        progressView.progressTintColor = .systemGray
        progressView.isUserInteractionEnabled = false
        progressView.alpha = 0.1
        return progressView
    }()
    
    private lazy var toggleButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 44)
        
        let playImage = UIImage(
            systemName: "play.circle",
            withConfiguration: imageConfig
        )?.withTintColor(.systemTeal, renderingMode: .alwaysOriginal)
        
        let pauseImage = UIImage(
            systemName: "pause.circle",
            withConfiguration: imageConfig
        )?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        
        button.setImage(playImage, for: .normal)
        button.setImage(pauseImage, for: .selected)
        return button
    }()
    
    private let resetButton = SymobolImageButton(size: 44, systemName: "checkmark.circle", color: .systemRed)
    private let restartButton = SymobolImageButton(size: 44, systemName: "repeat.circle", color: .systemIndigo)
    
    private var disposeBag = DisposeBag()
    var viewModel: TimerCellViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        timeLabel.text = nil
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
        
        restartButton.rx.tap
            .bind(to: input.restartButtonDidTap)
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
        
        output.isActive
            .map { !$0 }
            .bind(animated: initialTimeLabel.rx.animated.fade(duration: 0.3).isHidden)
            .disposed(by: disposeBag)
        
        output.toggleButtonIsSelected
            .bind(to: toggleButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.toggleButtonIsHidden
            .bind(to: toggleButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.resetButtonIsHidden
            .bind(to: resetButton.rx.isHidden, restartButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.progessRatio
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)
        
        output.cellCanTap
            .bind(to: cellTapButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Configuration

private extension TimerViewCell {
    func configureUI() {
        backgroundColor = .systemBackground
        configureSelectedBackgroundView()
    }
    
    func configureSelectedBackgroundView() {
        let backgroundView = UIView()
        selectedBackgroundView = backgroundView
    }
    
    func configureUI(with timer: Timer) {
        titleLabel.text = timer.name
        tagLabel.backgroundColor = timer.tag?.color.rgb ?? .clear
//        tagLabel.backgroundColor = timer.tag?.color.rgb
        timeLabel.text = timer.time.formattedRemainingSeconds
    }
}

// MARK: - UI Layout

private extension TimerViewCell {
    func layout() {
        contentView.addSubview(cellTapButton)
        contentView.addSubview(timerStackView)
        contentView.addSubview(initialTimeLabel)
        contentView.addSubview(progressView)
        contentView.bringSubviewToFront(cellTapButton)
        contentView.insertSubview(toggleButton, aboveSubview: cellTapButton)
        contentView.insertSubview(resetButton, aboveSubview: cellTapButton)
        contentView.addSubview(restartButton)
        
        cellTapButton.translatesAutoresizingMaskIntoConstraints = false
        cellTapButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellTapButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        cellTapButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellTapButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        timerStackView.translatesAutoresizingMaskIntoConstraints = false
        timerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        timerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        
        initialTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        initialTimeLabel.topAnchor.constraint(equalTo: timerStackView.bottomAnchor).isActive = true
        initialTimeLabel.leadingAnchor.constraint(equalTo: timerStackView.leadingAnchor).isActive = true
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        toggleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.trailingAnchor.constraint(equalTo: toggleButton.trailingAnchor).isActive = true
        resetButton.centerYAnchor.constraint(equalTo: toggleButton.centerYAnchor).isActive = true
        
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        restartButton.trailingAnchor.constraint(equalTo: toggleButton.leadingAnchor, constant: -8).isActive = true
        restartButton.centerYAnchor.constraint(equalTo: toggleButton.centerYAnchor).isActive = true
    }
}
