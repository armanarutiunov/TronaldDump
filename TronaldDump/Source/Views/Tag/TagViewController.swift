//
//  TagViewController.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 13.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import UIKit

class TagViewController: UIViewController {
	
	private let viewModel: TagViewModel
	
	private var tagView: TagView {
		guard let view = view as? TagView else {
			fatalError("Failed to cast view into TagView")
		}
		return view
	}
	
	init(viewModel: TagViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = TagView()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		title = viewModel.tagTitle
		tagView.configureTableView(with: self)
		viewModel.addObserver(self)
    }
}

extension TagViewController: UITableViewDataSource {
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

extension TagViewController: UITableViewDelegate {
	
}

extension TagViewController: TagViewModelObserver {
	func didFetchQuotes() {
		tagView.reloadTableView()
	}
}
