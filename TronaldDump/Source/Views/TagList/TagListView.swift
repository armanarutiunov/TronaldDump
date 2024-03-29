//
//  TagListView.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 12.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import UIKit

class TagListView: UIView {
    
    private struct Constants {
        struct TableView {
            static let cellIdentifier = "tagCell"
        }
    }
    
    private let tableView = UITableView()
    
    init() {
        super.init(frame: CGRect.zero)
        addSubviewsAndConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTableView(with viewController: UITableViewDataSource & UITableViewDelegate) {
        tableView.delegate = viewController
        tableView.dataSource = viewController
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.TableView.cellIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    // MARK: - Private
    
    private func addSubviewsAndConstraints() {
        addSubview(tableView)
        
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
