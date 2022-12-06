//
//  MainViewController.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/02.
//

import RxSwift
import RxRelay
import RxAppState

final class MainViewController: UIViewController, ViewType {
    
    private lazy var filteringSegmentControl: UISegmentedControl = {
//        let leftItemView = UIView()
//        leftItemView.backgroundColor = .red
//        let rightItemView = UIView()
//        rightItemView.backgroundColor = .blue
//        let segmentControl = UISegmentedControl(items: [leftItemView, rightItemView])
        let segmentControl = UISegmentedControl(items: [TimerFilteringCondition.all.title, TimerFilteringCondition.active.title])
        segmentControl.selectedSegmentIndex = TimerFilteringCondition.all.index
//        segmentControl.selectedSegmentIndex = ActiveFilteringType.active.index
        return segmentControl
    }()
    
    private lazy var tableViewDelegate = TimerTableViewDelegate()
    
//    private lazy var tableViewDragDelegate = TimerTableViewDragDelegate()
//    private lazy var tableViewDropDelegate = TimerTableViewDropDelegate()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 100
        tableView.register(TimerViewCell.self, forCellReuseIdentifier: TimerViewCell.identifier)
        tableView.delegate = tableViewDelegate
        
//        tableView.dragDelegate = tableViewDragDelegate
//        tableView.dropDelegate = tableViewDropDelegate
        tableView.dragInteractionEnabled = true
        
//        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
//        tableView.addGestureRecognizer(longPressRecognizer)
        return tableView
    }()
    
    //호출 순서에 따라 tabelView delegate가 설정 안될수도 있다?
    //diffableDataSource를 사용하면 기존 dataSource에서 사용할 수 있던 method들은 어떻게?
    private lazy var tableViewDiffableDataSource = TimerTableViewDiffableDataSource(tableView: tableView)
    
    private lazy var addTimerBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = "+"
        barButtonItem.style = .plain
        return barButtonItem
    }()
    
    private let disposeBag = DisposeBag()
    var viewModel: MainViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = addTimerBarButtonItem
        
        layout()
    }
    
    func bindInput(to viewModel: MainViewModel) {
        let input = viewModel.input
        
        tableViewDelegate.cellDidSwipeFromTrailing
            .bind(to: input.cellDidSwipeFromTrailing)
            .disposed(by: disposeBag)

        tableViewDelegate.cellDidSwipeFromLeading
            .bind(to: input.cellDidSwipeFromLeading)
            .disposed(by: disposeBag)
        
        addTimerBarButtonItem.rx.tap
            .bind(to: input.addTimerButtonDidTap)
            .disposed(by: disposeBag)
        
        filteringSegmentControl.rx.selectedSegmentIndex
            .compactMap { TimerFilteringCondition(rawValue: $0) }
            .bind(to: input.filteringSegmentDidTap)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(from viewModel: MainViewModel) {
        let output = viewModel.output
        
        output.filteredTimerCellViewModels
            .bind(onNext: tableViewDiffableDataSource.update)
            .disposed(by: disposeBag)
        
        output.pushTimerSettingViewModel
            .withUnretained(self)
            .bind { `self`, viewModel in
                let timerSettingViewController = TimerSettingViewController()
                timerSettingViewController.bind(viewModel: viewModel)
                self.navigationController?.pushViewController(timerSettingViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.presentTimerSettingViewModel
            .withUnretained(self)
            .bind { `self`, viewModel in
                let timerSettingViewController = TimerSettingViewController()
                timerSettingViewController.bind(viewModel: viewModel)
                self.present(timerSettingViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
//        @objc func longPressed(sender: UILongPressGestureRecognizer) {
//            tableViewDataSource.swapByLongPress(with: sender, to: tableView)
//        }
}

private extension MainViewController {
    func layout() {
        view.addSubview(tableView)
        view.addSubview(filteringSegmentControl)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: filteringSegmentControl.bottomAnchor, constant: 8).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        filteringSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        filteringSegmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        filteringSegmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        filteringSegmentControl.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
