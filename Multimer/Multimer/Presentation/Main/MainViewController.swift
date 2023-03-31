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
    
    private let swipeToStopNoticeView = SwipeRightToStopNoticeView()
    private let filteringNavigationTitleView = FilteringNavigationTitleView()
    
    private lazy var tableViewDelegate = TimerTableViewDelegate()
    private lazy var tableViewDiffableDataSource = TimerTableViewDiffableDataSource(tableView: tableView)
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = tableViewDelegate
        tableView.rowHeight = ViewSize.tableViewRowHeight
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.register(TimerViewCell.self, forCellReuseIdentifier: TimerViewCell.identifier)
        tableView.sectionFooterHeight = ViewSize.tableViewSectionFooterHeight
        tableView.sectionHeaderHeight = .zero
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    private lazy var emptyTimerView: EmptyTimerView = {
        let view = EmptyTimerView(timerFilteringCondition: .all)
        view.alpha = .zero
        return view
    }()
    
    private lazy var emptyActiveTimerView: EmptyTimerView = {
        let view = EmptyTimerView(timerFilteringCondition: .active)
        view.alpha = .zero
        return view
    }()
    
    private lazy var timerAddBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: ViewSize.timerAddBarButtonItemSize)
        
        let plusImage = UIImage(
            systemName: Constant.SFSymbolName.plus,
            withConfiguration: imageConfig
        )
        
        barButtonItem.image = plusImage
        return barButtonItem
    }()
    
    private lazy var resetAllActiveTimersButton: PaddingButton = {
        let button = PaddingButton(padding: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12), isRounded: true)
        button.setTitle(LocalizableString.resetAll.localized, for: .normal)
        button.backgroundColor = CustomColor.Button.resetAllActiveTimersButton
        button.isHidden = true
        button.alpha = .zero
        applyImpactFeedbackGenerator(to: button)
        return button
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
    
    private var impactFeedbackGenerator: UIImpactFeedbackGenerator? = .init(style: .medium)
    private let disposeBag = DisposeBag()
    var viewModel: MainViewModel? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layout()
        addShowSwipeToStopNoticeObserver()
        prepareFeedbackImpactGenerator()
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
        
        resetAllActiveTimersButton.rx.tap
            .bind(to: input.resetAllActiveTimersButtonDidTap)
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
        
        output.hideResetAllActiveTimersButton
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { `self`, isHidden in
                self.resetAllActiveTimersButton.shouldFadeIn(bool: !isHidden, withDuration: 0.25)
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
    
    deinit {
        impactFeedbackGenerator = nil
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
                self.emptyActiveTimerView.alpha = .zero
                self.emptyTimerView.isHidden = false
                self.emptyTimerView.alpha = 1.0
            case .active:
                self.emptyTimerView.isHidden = true
                self.emptyTimerView.alpha = .zero
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
    
    func addShowSwipeToStopNoticeObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showSwipeToStopNotice),
            name: Notification.Name.showSwipeToStopNotice,
            object: nil
        )
    }
}

// MARK: - Objc Selector Methods

private extension MainViewController {
    @objc func showSwipeToStopNotice() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            UIView.animate(withDuration: 0.75) {
                self.swipeToStopNoticeView.isHidden = false
                self.swipeToStopNoticeView.alpha = 1.0
                self.swipeToStopNoticeView.playAnimation()
            }
        }
    }
}

// MARK: - Feedback Generators

private extension MainViewController {
    func prepareFeedbackImpactGenerator() {
        impactFeedbackGenerator = UIImpactFeedbackGenerator()
        impactFeedbackGenerator?.prepare()
    }
    
    func applyImpactFeedbackGenerator(to button: UIButton) {
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.impactFeedbackGenerator?.impactOccurred()
        }), for: .touchUpInside)
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
        view.addSubview(swipeToStopNoticeView)
        view.addSubview(resetAllActiveTimersButton)
        
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
        
        swipeToStopNoticeView.translatesAutoresizingMaskIntoConstraints = false
        swipeToStopNoticeView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        swipeToStopNoticeView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        swipeToStopNoticeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        swipeToStopNoticeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        resetAllActiveTimersButton.translatesAutoresizingMaskIntoConstraints = false
        resetAllActiveTimersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetAllActiveTimersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
    
    func presentTimerEditingView(by isEditing: Bool) {
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

// MARK: - Name Space

private extension MainViewController {
    enum ViewSize {
        static let tableViewRowHeight: CGFloat = 100.0
        static let tableViewSectionFooterHeight: CGFloat = 50.0
        static let timerAddBarButtonItemSize = 18.0
    }
}
