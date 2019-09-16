//
//  MemeViewController.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 15.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController {

    private let viewModel: MemeViewModel
	
	private var memeView: MemeView {
		guard let view = view as? MemeView else {
			fatalError("Failed to cast view into MemeView")
		}
		return view
	}

    init(viewModel: MemeViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = MemeView()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		title = "Memes"
		viewModel.addObserver(self)
		setupView()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		viewModel.updateMeme()
	}
	
	// MARK: - Private
	
	private func setupView() {
		memeView.updateMemeButtonTitle = "Update Meme"
		memeView.didTapUpdateMemeButton = { [weak self] in
			self?.viewModel.updateMeme()
		}
	}
}

extension MemeViewController: MemeViewModelObserver {
	func didUpdateMeme() {
		memeView.memeImage = viewModel.image
	}
}
