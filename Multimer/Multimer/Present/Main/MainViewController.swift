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
    
    private lazy var filteringNavigationTitleView = FilteringNavigationTitleView()
    
    private lazy var tableViewDelegate = TimerTableViewDelegate()
    private lazy var tableViewDiffableDataSource = TimerTableViewDiffableDataSource(tableView: tableView)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = tableViewDelegate
        tableView.rowHeight = 100
        tableView.register(TimerViewCell.self, forCellReuseIdentifier: TimerViewCell.identifier)
        tableView.allowsMultipleSelectionDuringEditing = true
        return tableView
    }()
    
    private lazy var timerAddBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18)
        
        let plusImage = UIImage(
            systemName: "plus",
            withConfiguration: imageConfig
        )
        
        barButtonItem.image = plusImage
        return barButtonItem
    }()
    
    private lazy var timerEditBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = "편집"
        barButtonItem.style = .plain
        return barButtonItem
    }()
    
    private lazy var timerEditingView = TimerEditingView()
    private lazy var timerEditingViewTopAnchor: NSLayoutConstraint = timerEditingView.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50
    )
    
    private let disposeBag = DisposeBag()
    var viewModel: MainViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layout()
    }
    
    func bindInput(to viewModel: MainViewModel) {
        let input = viewModel.input
        
        rx.viewDidLoad
            .bind(to: input.viewDidLoad)
            .disposed(by: disposeBag)
        
        tableViewDelegate.cellDidSwipeFromTrailing
            .bind(to: input.cellDidSwipeFromTrailing)
            .disposed(by: disposeBag)
        
        tableViewDelegate.cellDidSwipeFromLeading
            .bind(to: input.cellDidSwipeFromLeading)
            .disposed(by: disposeBag)
        
        tableViewDelegate.selectedRows
            .bind(to: input.selectedRows)
            .disposed(by: disposeBag)
        
        tableViewDiffableDataSource.cellDidMove
            .bind(to: input.cellDidMove)
            .disposed(by: disposeBag)
        
        timerAddBarButtonItem.rx.tap
            .bind(to: input.timerAddButtonDidTap)
            .disposed(by: disposeBag)
        
        timerEditBarButtonItem.rx.tap
            .withUnretained(self) { `self`, _ -> Bool in
                return !self.tableView.isEditing
            }
            .bind(to: input.editButtonDidTap)
            .disposed(by: disposeBag)
        
        filteringNavigationTitleView.selectedSegmentIndex
            .bind(to: input.filteringSegmentControlDidTap)
            .disposed(by: disposeBag)
        
        timerEditingView.buttonInEditViewDidTap
            .bind(to: input.timerControlButtonInEditViewDidTap)
            .disposed(by: disposeBag)
        
        timerEditingView.deleteButtonDidTap
            .bind(to: input.deleteButtonInEditViewDidTap)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(from viewModel: MainViewModel) {
        let output = viewModel.output
        
        output.filteredTimerCellViewModels
            .observe(on: MainScheduler.instance)
            .bind(onNext: tableViewDiffableDataSource.update)
            .disposed(by: disposeBag)
        
        output.pushTimerSettingViewController
            .withUnretained(self)
            .bind { `self`, viewModel in
                let timerSettingViewController = TimerSettingViewController()
                timerSettingViewController.bind(viewModel: viewModel)
                self.navigationController?.pushViewController(timerSettingViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.presentTimerCreateViewController
            .withUnretained(self)
            .bind { `self`, viewModel in
                let timerCreateViewController = TimerCreateViewController()
                timerCreateViewController.bind(viewModel: viewModel)
                self.present(timerCreateViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.maintainEditingMode
            .withUnretained(self)
            .bind { `self`, isEditing in
                self.enterEditingMode(by: isEditing)
            }
            .disposed(by: disposeBag)
        
        output.enableEditViewButtons
            .bind(to: timerEditingView.enableButtons)
            .disposed(by: disposeBag)
        
        output.showDeleteConfirmAlert
            .withUnretained(self)
            .bind { `self`, count in
                self.showDeleteConfirmAlert(count: count, confirmHandler: { _ in
                    viewModel.input.confirmDeleteButtonDidTap.accept(())
                })
            }
            .disposed(by: disposeBag)
        
        output.deselectRows
            .withUnretained(self)
            .bind { `self`, rows in
                rows.forEach { self.tableView.deselectRow(at: IndexPath(row: $0, section: .zero), animated: true) }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Helper Methods

private extension MainViewController {
    func enterEditingMode(by isEditing: Bool) {
        self.timerEditBarButtonItem.title = isEditing ? "완료" : "편집"
        self.tableView.setEditing(isEditing, animated: true)
        self.presentTimerEditingView(by: isEditing)
    }
    
    func showDeleteConfirmAlert(count: Int, confirmHandler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: "타이머 삭제", message: "선택한 \(count)개의 타이머를 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .destructive))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: confirmHandler))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UI Configuration

private extension MainViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.titleView = filteringNavigationTitleView
        navigationItem.rightBarButtonItem = timerAddBarButtonItem
        navigationItem.leftBarButtonItem = timerEditBarButtonItem
    }
}

// MARK: - UI Layout

private extension MainViewController {
    func layout() {
        view.addSubview(tableView)
        view.addSubview(timerEditingView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        timerEditingView.translatesAutoresizingMaskIntoConstraints = false
        timerEditingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        timerEditingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        timerEditingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    func presentTimerEditingView(by isEditing: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.timerEditingViewTopAnchor.isActive = isEditing
            self.view.layoutIfNeeded()
        }
    }
}
