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
	var appCore: AppCore { get }
	
	func start()
}

struct MainCoordinator: Coordinator {
	let navigationController: UINavigationController
	let appCore: AppCore
	
	init(navigationController: UINavigationController, appCore: AppCore) {
		self.navigationController = navigationController
		self.appCore = appCore
	}
	
	func start() {
		let tagsViewModel = ConcreteTagsViewModel()
		let tagsViewController = TagsViewController(viewModel: tagsViewModel)
		navigationController.pushViewController(tagsViewController, animated: false)
	}
}
