//
//  QuoteListViewController.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 13.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import UIKit

class QuoteListViewController: UIViewController {
	
	private let viewModel: QuoteListViewModel
	
	private var quoteListView: QuoteListView {
		guard let view = view as? QuoteListView else {
			fatalError("Failed to cast view into QuoteListView")
		}
		return view
	}
	
	init(viewModel: QuoteListViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = QuoteListView()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		title = viewModel.tagTitle
		quoteListView.configureTableView(with: self)
		viewModel.addObserver(self)
    }
}

extension QuoteListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.quotes.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell") else {
			fatalError("Failed to dequeue quoteCell")
		}
		let quote = viewModel.quotes[indexPath.row]
		cell.textLabel?.text = quote.value
		return cell
	}
}

extension QuoteListViewController: UITableViewDelegate {
	
}

extension QuoteListViewController: QuoteListViewModelObserver {
	func didFetchQuotes() {
		quoteListView.reloadTableView()
	}
}
