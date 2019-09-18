//
//  SavedQuotesViewController.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 15.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import UIKit
import SafariServices

class SavedQuotesViewController: UIViewController {
	
	private let viewModel: SavedQuotesViewModel
	
	private var savedQuotesView: SavedQuotesView {
		guard let view = view as? SavedQuotesView else {
			fatalError("Failed to cast view into SavedQuotesView")
		}
		return view
	}

    init(viewModel: SavedQuotesViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = SavedQuotesView()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		title = "Saved"
		savedQuotesView.configureTableView(with: self)
		savedQuotesView.noResultsText = "No saved quotes found"
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		savedQuotesView.reloadTableView()
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

extension SavedQuotesViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.quotes.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedQuoteCell") else {
			fatalError("Failed to dequeue savedQuoteCell")
		}
		let quote = viewModel.quotes[indexPath.row]
		cell.textLabel?.text = quote.value
		cell.textLabel?.numberOfLines = 0
		return cell
	}
}

extension SavedQuotesViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		guard let sourceUrl = viewModel.sourceUrl(at: indexPath.row) else {
			notifyUserSourceUnknown()
			return
		}
		showSourceViewController(with: sourceUrl)
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else {
			return
		}
		viewModel.deleteQuote(at: indexPath.row)
		tableView.deleteRows(at: [indexPath], with: .fade)
		savedQuotesView.reloadTableView()
	}
}
