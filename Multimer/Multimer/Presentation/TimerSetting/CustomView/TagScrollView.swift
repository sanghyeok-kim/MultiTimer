//
//  TagScrollView.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/17.
//

import RxSwift
import RxCocoa

final class TagScrollView: UIScrollView {
    
    fileprivate let tagButtons = TagColor.allCases.map { TagButton(tag: Tag(color: $0)) }
    
    private lazy var contentView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: tagButtons)
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Layout

private extension TagScrollView {
    func layout() {
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: frameLayoutGuide.topAnchor, constant: 4).isActive = true
        contentView.bottomAnchor.constraint(equalTo: frameLayoutGuide.bottomAnchor, constant: -4).isActive = true
        
        contentView.heightAnchor.constraint(equalTo: contentLayoutGuide.heightAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor, constant: 8).isActive = true
        contentView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor, constant: -8).isActive = true
        
        tagButtons.forEach {
            $0.widthAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        }
    }
}

// MARK: - Reactive Extension

extension Reactive where Base: TagScrollView {
    var tagDidSelect: ControlEvent<Tag> {
        let source = Observable<Tag>.merge(base.tagButtons.map { $0.rx.tagDidSelect.asObservable() })
        return ControlEvent(events: source)
    }
    
    var selectTag: Binder<Tag> {
        return Binder(base) { tagScrollView, tag in
            tagScrollView.tagButtons.forEach {
                $0.rx.selectTag.onNext(tag.color)
            }
        }
    }
}
