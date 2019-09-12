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
		return view as! TagsView
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
	}
	
}

extension TagsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell") as? TagCell else {
			return UITableViewCell()
		}
		
		return cell
	}
}

extension TagsViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
}
