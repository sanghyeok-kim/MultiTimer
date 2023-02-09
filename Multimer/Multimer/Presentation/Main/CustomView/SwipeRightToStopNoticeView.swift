//
//  SwipeRightToStopNoticeView.swift
//  Multimer
//
//  Created by 김상혁 on 2023/02/08.
//

import RxSwift
import Lottie

final class SwipeRightToStopNoticeView: UIView {
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        view.alpha = 0.85
        return view
    }()
    
    private lazy var swipeAnimationView: LottieAnimationView = {
        let lottieView = LottieAnimationView(name: Constant.LottieAnimationName.swipeRightToStopTimer)
        lottieView.loopMode = .repeat(2)
        return lottieView
    }()
    
    private lazy var tapAnimationView: LottieAnimationView = {
        let lottieView = LottieAnimationView(name: Constant.LottieAnimationName.tap)
        lottieView.loopMode = .playOnce
        lottieView.isHidden = true
        return lottieView
    }()
    
    private lazy var cellImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: Constant.AssetImageName.swipeCellRightToStop))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var noticeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = LocalizableString.swipeRightToStop.localized
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        configureUI()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Providing Functions

extension SwipeRightToStopNoticeView {
    func playAnimation() {
        swipeAnimationView.play { [weak self] _ in
            self?.tapAnimationView.isHidden = false
            self?.tapAnimationView.play { _ in
                UIView.animate(withDuration: 0.75) {
                    self?.alpha = .zero
                } completion: { _ in
                    self?.isHidden = true
                }
            }
        }
    }
}

// MARK: - UI Configuration

private extension SwipeRightToStopNoticeView {
    func configureUI() {
        isHidden = true
        alpha = .zero
    }
}

// MARK: - UI Layout

private extension SwipeRightToStopNoticeView {
    func layout() {
        addSubview(backgroundView)
        addSubview(cellImageView)
        addSubview(swipeAnimationView)
        addSubview(tapAnimationView)
        addSubview(noticeLabel)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        cellImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        cellImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35).isActive = true
        cellImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cellImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        swipeAnimationView.translatesAutoresizingMaskIntoConstraints = false
        swipeAnimationView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        swipeAnimationView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
        swipeAnimationView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 20).isActive = true
        swipeAnimationView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 40).isActive = true
        
        tapAnimationView.translatesAutoresizingMaskIntoConstraints = false
        tapAnimationView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
        tapAnimationView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        tapAnimationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        tapAnimationView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 20).isActive = true
        
        noticeLabel.translatesAutoresizingMaskIntoConstraints = false
        noticeLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        noticeLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        noticeLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        noticeLabel.bottomAnchor.constraint(equalTo: cellImageView.topAnchor).isActive = true
    }
}
