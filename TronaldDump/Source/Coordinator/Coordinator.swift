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
		let tagsViewModel = ConcreteTagListViewModel(tagService: serviceContainer.tagService)
		let tagsViewController = TagListViewController(viewModel: tagsViewModel)
		navigationController.pushViewController(tagsViewController, animated: false)
	}
}
