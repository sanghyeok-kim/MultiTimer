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
        setImage(UIImage(systemName: "checkmark"), for: .selected)
        backgroundColor = tag.color.rgb
        isSelected = tag.isSelected
        
        rx.tap
            .map { tag }
            .bind(to: didTap)
            .disposed(by: disposeBag)
        
        selectedButtonColor
            .bind(onNext: toggleSelected)
            .disposed(by: disposeBag)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = min(frame.width, frame.height) / 2
    }
    
    private func toggleSelected(by selectedButtonColor: TagColor) {
        isSelected = tagState.color == selectedButtonColor
        tagState.isSelected = isSelected //???????????????????????????????????????????????????????
    }
}
