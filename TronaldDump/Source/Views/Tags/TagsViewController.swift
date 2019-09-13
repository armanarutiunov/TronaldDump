//
//  TagsViewController.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 12.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import UIKit

class TagsViewController: UIViewController {
	
	private let viewModel: TagsViewModel
	
	private var tagsView: TagsView {
		guard let view = view as? TagsView else {
			fatalError("Failed to cast view into TagsView")
		}
		return view
	}
	
	init(viewModel: TagsViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = TagsView()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Tags"
		tagsView.configureTableView(with: self)
		viewModel.addObserver(self)
	}
	
}

extension TagsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.tags.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell") else {
			fatalError("Failed to dequeue tagCell")
		}
		let tag = viewModel.tags[indexPath.row]
		cell.textLabel?.text = tag.title
		return cell
	}
}

extension TagsViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
}

extension TagsViewController: TagViewModelObserver {
	func didFetchTags() {
		tagsView.reloadTableView()
	}
}
