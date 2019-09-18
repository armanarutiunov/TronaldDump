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
	private let searchController = UISearchController(searchResultsController: nil)
	
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
		quoteListView.noResultsText = "No results for your query"
		viewModel.addObserver(self)
		configureSearchController()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		quoteListView.reloadTableView()
	}
	
	// MARK: - Private
	
	private func configureSearchController() {
		guard viewModel.isSearchEnabled else {
			return
		}
		if #available(iOS 11.0, *) {
			navigationItem.searchController = searchController
			navigationItem.hidesSearchBarWhenScrolling = false
		} else {
			quoteListView.setTableHeaderView(searchController.searchBar)
		}
		definesPresentationContext = true
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search"
		searchController.searchBar.delegate = self
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
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell") as? QuoteCell else {
			fatalError("Failed to dequeue quoteCell")
		}
		let quote = viewModel.quotes[indexPath.row]
		cell.quoteText = quote.value
		cell.isBookmarked = viewModel.isQuoteSaved(at: indexPath.row)
		cell.didUpdateSavedState = { [weak self] in
			guard let self = self else {
				return
			}
			self.viewModel.updateQuoteState(at: indexPath.row)
			cell.isBookmarked = self.viewModel.isQuoteSaved(at: indexPath.row)
		}
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

extension QuoteListViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		if let query = searchBar.text {
			viewModel.searchQuotes(with: query)
		}
	}
}

extension QuoteListViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		if let query = searchController.searchBar.text {
			viewModel.searchQuotes(with: query)
		}
	}
}

