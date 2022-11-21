//
//  TagScrollView.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/17.
//

import RxSwift
import RxRelay

final class TagScrollView: UIScrollView {
    
    let tagDidSelect = PublishRelay<Tag?>()
    private let disposeBag = DisposeBag()
    
    private let contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //TagButton 생성
        let tagButtons = TagColor.allCases.map { TagButton(tag: Tag(color: $0)) }
        contentView.addArrangedSubviews(tagButtons)
        
        //모든 TagButton에서 발생하는 이벤트를 merge해서 tagDidSelect로 전달
        Observable<Tag>
            .merge(tagButtons.map { $0.didTap.asObservable() })
            .bind(to: tagDidSelect)
            .disposed(by: disposeBag)
        
        //tagDidSelect에서 발생하는 이벤트를 모든 TagButton들에게 broadcast
        tagDidSelect
            .compactMap { $0?.color }
            .bind { color in
                tagButtons.forEach { $0.selectedButtonColor.accept(color) }
            }
            .disposed(by: disposeBag)
        
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TagScrollView {
    func layout() {
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor, constant: 4).isActive = true
        contentView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor, constant: -4).isActive = true
        contentView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor, constant: 4).isActive = true
        contentView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor, constant: -4).isActive = true
        contentView.heightAnchor.constraint(equalTo: frameLayoutGuide.heightAnchor, constant: -8).isActive = true
    }
}
