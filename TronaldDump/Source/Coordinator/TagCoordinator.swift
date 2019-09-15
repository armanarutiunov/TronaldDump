//
//  TagCoordinator.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 15.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import UIKit

class TagCoordinator: Coordinator {
	let navigationController: UINavigationController
	var serviceContainer: ServiceContainer
	
	init(navigationController: UINavigationController, serviceContainer: ServiceContainer) {
		self.navigationController = navigationController
		self.serviceContainer = serviceContainer
	}
	
	func start() {
		let viewModel = ConcreteTagListViewModel(tagService: serviceContainer.tagService)
		viewModel.selectTagCommand = { [weak self] tagTitle in
			self?.goToTagScreen(tagTitle)
		}
		let viewController = TagListViewController(viewModel: viewModel)
		navigationController.pushViewController(viewController, animated: false)
	}
	
	func goToTagScreen(_ tagTitle: String) {
		let viewModel = ConcreteQuoteListViewModel(tagService: serviceContainer.tagService, tagTitle: tagTitle)
		let viewController = QuoteListViewController(viewModel: viewModel)
		navigationController.pushViewController(viewController, animated: true)
	}
}
