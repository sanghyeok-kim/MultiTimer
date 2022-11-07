//
//  MainViewController.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/02.
//

import RxSwift
import RxRelay

final class MainViewController: UIViewController, ViewType {
    
    private let disposeBag = DisposeBag()
    
    private lazy var tableViewDelegate = TimerTableViewDelegate()
    private lazy var tableViewDataSource = TimerTableViewDataSource()
//    private lazy var tableViewDragDelegate = TimerTableViewDragDelegate()
//    private lazy var tableViewDropDelegate = TimerTableViewDropDelegate()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 100
        tableView.register(TimerViewCell.self, forCellReuseIdentifier: TimerViewCell.identifier)
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
//        tableView.dragDelegate = tableViewDragDelegate
//        tableView.dropDelegate = tableViewDropDelegate
        tableView.dragInteractionEnabled = true
        
//        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
//        tableView.addGestureRecognizer(longPressRecognizer)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
//        tableView.rx.dataSource
        layout()
    }
    
    func bind(to viewModel: MainViewModel) {
        let input = MainViewModel.Input(
            cellDidSwipe: tableViewDelegate.cellDidSwipe.asObservable()
//            cellDidMove: tableViewDelegate.cellDidMove.asObservable()
        )
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        output.timerCellViewModels.bind { [weak self] cellViewModels in
            guard let self = self else { return }
            self.tableViewDataSource.update(timerCellViewModels: cellViewModels)
        }.disposed(by: disposeBag)
    }
    
//        @objc func longPressed(sender: UILongPressGestureRecognizer) {
//            tableViewDataSource.swapByLongPress(with: sender, to: tableView)
//        }
}

private extension MainViewController {
    func layout() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}
