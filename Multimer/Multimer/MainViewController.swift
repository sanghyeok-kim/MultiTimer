//
//  MainViewController.swift
//  Multimer
//
//  Created by 김상혁 on 2022/11/02.
//

import UIKit

class MainViewController: UIViewController {
    private lazy var tableViewDelegate = TimerTableViewDelegate()
    private lazy var tableViewDataSource = TimerTableViewDataSource()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = tableViewDataSource
        tableView.delegate = tableViewDelegate
        tableView.register(TimerViewCell.self, forCellReuseIdentifier: TimerViewCell.identifier)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        tableView.addGestureRecognizer(longPressRecognizer)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        layout()
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        tableViewDataSource.swapByLongPress(with: sender, to: tableView)
    }
}

private extension MainViewController {
    func layout() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

