//
//  SoundSettingViewController.swift
//  Multimer
//
//  Created by 김상혁 on 2023/07/30.
//

import AVFoundation
import UIKit

import ReactorKit
import RxCocoa

final class RingtoneSelectViewController: UIViewController, View {
    private lazy var tableViewDiffableDataSource = RingtoneSelectTableViewDiffableDataSource(tableView: tableView)
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(RingtoneViewCell.self, forCellReuseIdentifier: RingtoneViewCell.identifier)
        tableView.backgroundColor = .systemGray5
        return tableView
    }()
    
    
    private let closeBarButton = UIBarButtonItem(systemItem: .close)
    
    private var audioPlayer: AVAudioPlayer?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        navigationItem.rightBarButtonItem = closeBarButton
    }
    
    func bind(reactor: RingtoneSelectReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
}

// MARK: - Bind Reactor

private extension RingtoneSelectViewController {
    func bindAction(reactor: RingtoneSelectReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { Reactor.Action.ringtoneDidSelect($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: RingtoneSelectReactor) {
        reactor.state.map { $0.ringtoneCellModelMap }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: tableViewDiffableDataSource.applySnapshot)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.ringtoneToPlay }
            .distinctUntilChanged()
            .compactMap { $0 }
            .bind(with: self) { `self`, ringtoneToPlay in
                self.play(ringtone: ringtoneToPlay)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Layout

private extension RingtoneSelectViewController {
    func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -6).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: - Supporting Methods

private extension RingtoneSelectViewController {
    func play(ringtone: Ringtone) {
        if let url = Bundle.main.url(forResource: ringtone.name, withExtension: Constant.Ringtone.extension) {
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        }
    }
}
