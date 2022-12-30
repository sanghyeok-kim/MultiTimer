//
//  FilteringNavigationTitleView.swift
//  Multimer
//
//  Created by 김상혁 on 2022/12/17.
//

import RxSwift
import RxRelay

final class FilteringNavigationTitleView: UIView {
    
    let selectedSegmentIndex = BehaviorRelay<TimerFilteringCondition>(value: .all)
    
    private lazy var filteringSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: [TimerFilteringCondition.all.title, TimerFilteringCondition.active.title])
        segmentControl.selectedSegmentIndex = TimerFilteringCondition.all.index
        for index in 0..<TimerFilteringCondition.allCases.count {
            segmentControl.setWidth(100, forSegmentAt: index)
        }
        segmentControl.sizeToFit()
        return segmentControl
    }()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bindSegmentControlDidSelected()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindSegmentControlDidSelected() {
        filteringSegmentControl.rx.selectedSegmentIndex
            .compactMap { TimerFilteringCondition(rawValue: $0) }
            .bind(to: selectedSegmentIndex)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Layout

private extension FilteringNavigationTitleView {
    func layout() {
        addSubview(filteringSegmentControl)
        
        filteringSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        filteringSegmentControl.topAnchor.constraint(equalTo: topAnchor).isActive = true
        filteringSegmentControl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        filteringSegmentControl.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        filteringSegmentControl.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
