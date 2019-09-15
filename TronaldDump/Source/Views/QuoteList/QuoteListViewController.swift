//
//  QuoteListViewController.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 13.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import UIKit
import SafariServices

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
	
	private func notifyUserSourceUnknown() {
		let alertController = UIAlertController(title: "Quote source is unkown", message: nil, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alertController.addAction(okAction)
		present(alertController, animated: true, completion: nil)
	}
	
	private func showSourceViewController(with sourceUrl: URL) {
		let sourceViewController = SFSafariViewController(url: sourceUrl)
		present(sourceViewController, animated: true, completion: nil)
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
		cell.textLabel?.numberOfLines = 0
		return cell
	}
}

extension QuoteListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		guard let sourceUrl = viewModel.sourceUrl(at: indexPath.row) else {
			notifyUserSourceUnknown()
			return
		}
		showSourceViewController(with: sourceUrl)
	}
}

extension QuoteListViewController: QuoteListViewModelObserver {
	func didFetchQuotes() {
		quoteListView.reloadTableView()
	}
	
}
