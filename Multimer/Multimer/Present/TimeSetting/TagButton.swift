//
//  TagButton.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/17.
//

import RxSwift
import RxRelay

final class TagButton: UIButton {
    
    let selectedButtonColor = PublishRelay<TagColor>()
    let didTap = PublishRelay<Tag>()
    
    private var tagState: Tag
    private let disposeBag = DisposeBag()
    
    init(tag: Tag) {
        self.tagState = tag
        super.init(frame: .zero)
        configureUI(with: tag)
        bindDidTap(with: tag)
        bindSelectedButtonColor()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = max(layer.frame.size.width, layer.frame.size.height) / 2
    }
    
    private func bindDidTap(with tag: Tag) {
        rx.tap
            .map { tag }
            .bind(to: didTap)
            .disposed(by: disposeBag)
    }
    
    private func bindSelectedButtonColor() {
        selectedButtonColor
            .withUnretained(self)
            .bind { `self`, color in
                self.toggleSelected(by: color)
            }
            .disposed(by: disposeBag)
    }
    
    private func toggleSelected(by selectedButtonColor: TagColor) {
        isSelected = tagState.color == selectedButtonColor
        tagState.isSelected = isSelected
    }
}

private extension TagButton {
    func configureUI(with tag: Tag) {
        let checkmarkImage = UIImage(
            systemName: "checkmark"
        )?.withTintColor(CustomColor.Tag.checkmarkImage, renderingMode: .alwaysOriginal)
        setImage(checkmarkImage, for: .selected)
        backgroundColor = tag.color.uiColor
        isSelected = tag.isSelected
    }
}
