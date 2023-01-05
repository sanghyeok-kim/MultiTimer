//
//  TagScrollView.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/17.
//

import RxSwift
import RxRelay

final class TagScrollView: UIScrollView {
    
    let tagDidSelect = BehaviorRelay<Tag?>(value: Tag(color: .label))
    
    private lazy var tagButtons = TagColor.allCases.map { TagButton(tag: Tag(color: $0)) }
    
    private lazy var contentView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: tagButtons)
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bindTagButtonsDidTap(from: tagButtons)
        bindTagDidSelect(to: tagButtons)
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindTagButtonsDidTap(from tagButtons: [TagButton]) {
        Observable<Tag>
            .merge(tagButtons.map { $0.didTap.asObservable() })
            .bind(to: tagDidSelect)
            .disposed(by: disposeBag)
    }
    
    private func bindTagDidSelect(to tagButtons: [TagButton]) {
        tagDidSelect
            .compactMap { $0?.color }
            .bind { color in
                tagButtons.forEach { $0.selectedButtonColor.accept(color) }
            }
            .disposed(by: disposeBag)
    }
}

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
