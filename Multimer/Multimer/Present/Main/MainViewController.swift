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
        let input = MainViewModel.Input(
            viewDidLoad: rx.viewDidLoad.asObservable(),
            cellDidSwipe: tableViewDelegate.cellDidSwipe.asObservable(),
            addTimerButtonDidTap: addTimerBarButtonItem.rx.tap.asObservable()
//            cellDidMove: tableViewDelegate.cellDidMove.asObservable()
        )
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        //1. 맨 처음 영구 저장소에서 받아온 저장되어있는 타이머 불러올 때 [Timer] -> reload X
        //2. 새로운 타이머를 추가했을 때 [Timer] + Timer -> reloadRows(at:)
        //3. 타이머를 삭제했을 때 [Timer] - Timer -> deleteRows(at:)
        output.timerCellViewModels
            .withUnretained(self)
            .bind { `self`, cellViewModels in
                self.tableViewDataSource.update(timerCellViewModels: cellViewModels)
                self.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        // FIXME: append된 경우엔 마지막 index만 reload하면 됨, swipe-to-delete 발생시 reloadData하면 안됨
        
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
