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
    }
}
