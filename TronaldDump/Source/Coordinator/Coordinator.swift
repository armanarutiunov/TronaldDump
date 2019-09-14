//
//  Coordinator.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 12.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import UIKit

protocol Coordinator {
	var navigationController: UINavigationController { get }
	var serviceContainer: ServiceContainer { get }
	
	func start()
}

class MainCoordinator: Coordinator {
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
		let viewModel = ConcreteTagViewModel(tagService: serviceContainer.tagService, tagTitle: tagTitle)
		let viewController = TagViewController(viewModel: viewModel)
		navigationController.pushViewController(viewController, animated: true)
	}
}
