//
//  QuoteListView.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 13.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import UIKit

class QuoteListView: UIView {
    
    private struct Constants {
        struct TableView {
            static let cellIdentifier = "quoteCell"
        }
    }
    
    private let tableView = UITableView()
    private let noResultsLabel = UILabel()
    
    var noResultsText: String {
        get {
            noResultsLabel.text ?? ""
        }
        set {
            noResultsLabel.text = newValue
        }
    }
    
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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.register(QuoteCell.self, forCellReuseIdentifier: Constants.TableView.cellIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    func setTableHeaderView(_ view: UIView) {
        tableView.tableHeaderView = view
    }
    
    func reloadTableView() {
        tableView.reloadData()
        noResultsLabel.isHidden = tableView.numberOfRows(inSection: 0) > 0
    }
    
    // MARK: - Private
    
    private func addSubviewsAndConstraints() {
        addSubview(tableView)
        addSubview(noResultsLabel)
        
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            noResultsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
