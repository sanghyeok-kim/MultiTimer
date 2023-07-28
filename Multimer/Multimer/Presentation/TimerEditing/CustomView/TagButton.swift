//
//  TagButton.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/17.
//

import RxSwift
import RxCocoa

final class TagButton: UIButton {
    
    fileprivate var tagState: Tag
    
    init(tag: Tag) {
        self.tagState = tag
        super.init(frame: .zero)
        configureUI(with: tag)
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
    
    fileprivate func toggleSelected(by selectedButtonColor: TagColor) {
        isSelected = tagState.color == selectedButtonColor
        tagState.isSelected = isSelected
    }
}

// MARK: - UI Configuration

private extension TagButton {
    func configureUI(with tag: Tag) {
        let checkmarkImage = UIImage(
            systemName: Constant.SFSymbolName.checkmark
        )?.withTintColor(CustomColor.Tag.checkmarkImage, renderingMode: .alwaysOriginal)
        setImage(checkmarkImage, for: .selected)
        backgroundColor = TagColorFactory.generateUIColor(of: tag.color)
        isSelected = tag.isSelected
    }
}

// MARK: - Reactive Extension

extension Reactive where Base: TagButton {
    var tagDidSelect: ControlEvent<Tag> {
        let source = controlEvent(.touchUpInside).map { base.tagState }
        return ControlEvent(events: source)
    }
    
    var selectTag: Binder<TagColor> {
        return Binder(base) { button, color in
            button.toggleSelected(by: color)
        }
    }
}
