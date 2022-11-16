//
//  TimerViewCell.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import RxSwift
import RxCocoa

final class TimerViewCell: UITableViewCell, CellIdentifiable, ViewType {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGreen // FIXME: 삭제
        return label
    }()
    
    private lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .brown // FIXME: 삭제
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.backgroundColor = .blue // FIXME: 삭제
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let titleStackView = UIStackView()
        titleStackView.axis = .horizontal
        titleStackView.spacing = 2
        titleStackView.distribution = .equalSpacing
        titleStackView.addArrangedSubviews([titleLabel, tagLabel])
        return titleStackView
    }()
    
    private lazy var timerStackView: UIStackView = {
        let timerStackView = UIStackView()
        timerStackView.axis = .vertical
        timerStackView.spacing = 4
        timerStackView.distribution = .equalSpacing
        timerStackView.alignment = .leading
        timerStackView.addArrangedSubviews([titleStackView, timeLabel])
        timerStackView.backgroundColor = .orange // FIXME: 삭제
        return timerStackView
    }()
    
    private lazy var toggleButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 36)
        let playImage = UIImage(
            systemName: "play.circle",
            withConfiguration: imageConfig
        )?.withTintColor(.systemTeal, renderingMode: .alwaysOriginal)
        
        let pauseImage = UIImage(
            systemName: "pause.circle",
            withConfiguration: imageConfig
        )?.withTintColor(.systemTeal, renderingMode: .alwaysOriginal)
        
        button.setImage(playImage, for: .normal)
        button.setImage(pauseImage, for: .selected)
        return button
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 36)
        
        let restartImage = UIImage(
            systemName: "repeat.circle",
            withConfiguration: imageConfig
        )?.withTintColor(.magenta, renderingMode: .alwaysOriginal)
        
        button.setImage(restartImage, for: .normal)
        return button
    }()
    
    private let cellTapButton = UIButton()
    
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.isUserInteractionEnabled = false
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        tagLabel.text = nil
        timeLabel.text = nil
        disposeBag = DisposeBag()
    }
    
    func bind(to viewModel: TimerCellViewModel) {
        bindInput(to: viewModel)
        bindOutput(from: viewModel)
    }
    
    private func bindInput(to viewModel: TimerCellViewModel) {
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
    
    private func bindOutput(from viewModel: TimerCellViewModel) {
        let output = viewModel.output
        
        output.timer
            .withUnretained(self)
            .bind { `self`, timer in
                self.titleLabel.text = timer.name
                self.tagLabel.text = timer.tag
            }.disposed(by: disposeBag)
        
        output.timer
            .map { $0.time.formattedString }
            .bind(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.toggleButtonIsSelected
            .bind(to: toggleButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output.toggleButtonIsHidden
            .bind(to: toggleButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.restartButtonIsHidden
            .bind(to: resetButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

// MARK: - View Layout

private extension TimerViewCell {
    func layout() {
        addSubview(cellTapButton)
        addSubview(timerStackView)
        addSubview(toggleButton)
        addSubview(resetButton)
        
        bringSubviewToFront(toggleButton)
        
        cellTapButton.translatesAutoresizingMaskIntoConstraints = false
        cellTapButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cellTapButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cellTapButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cellTapButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        timerStackView.translatesAutoresizingMaskIntoConstraints = false
        timerStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        timerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        toggleButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.trailingAnchor.constraint(equalTo: toggleButton.trailingAnchor).isActive = true
        resetButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}

