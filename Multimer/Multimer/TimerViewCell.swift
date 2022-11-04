//
//  TimerViewCell.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/03.
//

import RxSwift
import RxCocoa

final class TimerViewCell: UITableViewCell, Identifiable, ViewType {
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
        let buttonImage = UIImage(
            systemName: "play.circle",
            withConfiguration: imageConfig
        )?.withTintColor(.systemTeal, renderingMode: .alwaysOriginal)
        
        button.setImage(buttonImage, for: .normal)
        return button
    }()
    
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func bind(to viewModel: TimerCellViewModel) {
        let input = TimerCellViewModel.Input(
            toggleButtonDidTap: toggleButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(from: input)
        
        output.timer.bind { [weak self] timer in
            self?.titleLabel.text = timer.name
            self?.tagLabel.text = timer.tag
            self?.timeLabel.text = timer.time
        }.disposed(by: disposeBag)
    }
}

// MARK: - View Layout

private extension TimerViewCell {
    func layout() {
        addSubview(timerStackView)
        addSubview(toggleButton)
        
        timerStackView.translatesAutoresizingMaskIntoConstraints = false
        timerStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        timerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        toggleButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
