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
    
    private let disposeBag = DisposeBag()
    
    private lazy var tableViewDelegate = TimerTableViewDelegate()
    
//    private lazy var tableViewDragDelegate = TimerTableViewDragDelegate()
//    private lazy var tableViewDropDelegate = TimerTableViewDropDelegate()
    
    private lazy var tableViewDiffableDataSource = TimerTableViewDiffableDataSource(tableView: tableView)
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
    
    private lazy var addTimerBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = "+"
        barButtonItem.style = .plain
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = addTimerBarButtonItem
        layout()
    }
    
    func bind(to viewModel: MainViewModel) {
        bindInput(to: viewModel)
        bindOutput(from: viewModel)
    }
    
    private func bindInput(to viewModel: MainViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        tableViewDelegate.cellDidSwipe
            .bind(to: input.cellDidSwipe)
            .disposed(by: disposeBag)
        
        addTimerBarButtonItem.rx.tap
            .bind(to: input.addTimerButtonDidTap)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(from viewModel: MainViewModel) {
        let output = viewModel.output
        
        output.timerCellViewModels
            .bind(onNext: tableViewDiffableDataSource.update)
            .disposed(by: disposeBag)
        
        output.pushTimerSettingViewModel
            .withUnretained(self)
            .bind { `self`, viewModel in
                let timerSettingViewController = TimerSettingViewController()
                timerSettingViewController.viewModel = viewModel
                self.navigationController?.pushViewController(timerSettingViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.presentTimerSettingViewModel
            .withUnretained(self)
            .bind { `self`, viewModel in
                let timerSettingViewController = TimerSettingViewController()
                timerSettingViewController.viewModel = viewModel
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
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}
