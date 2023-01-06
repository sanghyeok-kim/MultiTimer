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
    
    private let filteringNavigationTitleView = FilteringNavigationTitleView()
    
    private lazy var tableViewDelegate = TimerTableViewDelegate()
    private lazy var tableViewDiffableDataSource = TimerTableViewDiffableDataSource(tableView: tableView)
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = tableViewDelegate
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(TimerViewCell.self, forCellReuseIdentifier: TimerViewCell.identifier)
        //        tableView.register(TimerTableFooterView.self, forHeaderFooterViewReuseIdentifier: TimerTableFooterView.identifier)
        tableView.sectionFooterHeight = 50
        tableView.sectionHeaderHeight = .zero
        return tableView
    }()
    
    private lazy var emptyTimerView: EmptyTimerView = {
        let view = EmptyTimerView(timerFilteringCondition: .all)
        view.alpha = 0
        return view
    }()
    
    private lazy var emptyActiveTimerView: EmptyTimerView = {
        let view = EmptyTimerView(timerFilteringCondition: .active)
        view.alpha = 0
        return view
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
        barButtonItem.title = LocalizableString.edit.localized
        barButtonItem.style = .plain
        return barButtonItem
    }()
    
    private lazy var timerEditingView = TimerEditingView()
    private lazy var timerEditingViewTopAnchor = timerEditingView.topAnchor.constraint(
        equalTo: view.bottomAnchor
    )
    private lazy var timerViewTopAnchorWhileEditing = timerEditingView.topAnchor.constraint(
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
        
        output.showEmptyTimerView
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { `self`, filteringCondition in
                self.showEmptyTimerView(of: filteringCondition)
            }
            .disposed(by: disposeBag)
        
        output.hideEmptyTimerView
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { `self`, _ in
                self.hideEmptyTimerView()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Helper Methods

private extension MainViewController {
    func showEmptyTimerView(of filteringCondition: TimerFilteringCondition) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            switch filteringCondition {
            case .all:
                self.emptyActiveTimerView.isHidden = true
                self.emptyActiveTimerView.alpha = 0
                self.emptyTimerView.isHidden = false
                self.emptyTimerView.alpha = 1.0
            case .active:
                self.emptyTimerView.isHidden = true
                self.emptyTimerView.alpha = 0
                self.emptyActiveTimerView.isHidden = false
                self.emptyActiveTimerView.alpha = 1.0
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func hideEmptyTimerView() {
        self.emptyTimerView.isHidden = true
        self.emptyActiveTimerView.isHidden = true
    }
    
    func enterEditingMode(by isEditing: Bool) {
        let doneString = LocalizableString.done.localized
        let editString = LocalizableString.edit.localized
        timerEditBarButtonItem.title = isEditing ? doneString : editString
        tableView.setEditing(isEditing, animated: true)
        presentTimerEditingView(by: isEditing)
    }
    
    func showDeleteConfirmAlert(count: Int, confirmHandler: @escaping (UIAlertAction) -> Void) {
        let deleteTimerString = LocalizableString.deleteTimer.localized
        let deleteConfirmMessageString = LocalizableString.deleteConfirmMessage(count: count).localized
        let cancelString = LocalizableString.cancel.localized
        let deleteString = LocalizableString.delete.localized
        
        let alert = UIAlertController(title: deleteTimerString, message: deleteConfirmMessageString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelString, style: .default))
        alert.addAction(UIAlertAction(title: deleteString, style: .destructive, handler: confirmHandler))
        present(alert, animated: true, completion: nil)
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
        view.addSubview(emptyTimerView)
        view.addSubview(emptyActiveTimerView)
        view.addSubview(timerEditingView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        emptyTimerView.translatesAutoresizingMaskIntoConstraints = false
        emptyTimerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        emptyTimerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        emptyTimerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        emptyTimerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        emptyActiveTimerView.translatesAutoresizingMaskIntoConstraints = false
        emptyActiveTimerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        emptyActiveTimerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        emptyActiveTimerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        emptyActiveTimerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        timerEditingView.translatesAutoresizingMaskIntoConstraints = false
        timerEditingViewTopAnchor.isActive = true
        timerEditingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        timerEditingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        timerEditingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    func presentTimerEditingView(by isEditing: Bool) {
        // updateCycle상 아직 업데이트 되지 않은 layout이 있다면 animate 블록 안에서 layoutIfNeeded를 호출할 때 같이 업데이트 되므로,
        // 그 전에 한 번 layoutIfNeeded를 호출해서 의도치않은 애니메이션을 방지
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3) {
            switch isEditing {
            case true:
                self.timerEditingViewTopAnchor.isActive = false
                self.timerViewTopAnchorWhileEditing.isActive = true
            case false:
                self.timerViewTopAnchorWhileEditing.isActive = false
                self.timerEditingViewTopAnchor.isActive = true
            }
            self.view.layoutIfNeeded()
        }
    }
}
