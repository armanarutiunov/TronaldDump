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
	let navigationController = UINavigationController()
	var serviceContainer: ServiceContainer
	
	private let tabBarController: UITabBarController
	
	private lazy var tagCoordinator: Coordinator = {
		let controller = navigationController(title: "Tags", image: UIImage(named: "tags"))
		let tagCoordinator = TagCoordinator(navigationController: controller, serviceContainer: serviceContainer)
		tagCoordinator.start()
		return tagCoordinator
	}()
	
	private lazy var quoteSearchCoordinator: Coordinator = {
		let controller = navigationController(title: "Search", image: UIImage(named: "search"))
		let coordinator = QuoteSearchCoordinator(navigationController: controller, serviceContainer: serviceContainer)
		coordinator.start()
		return coordinator
	}()
	
	private lazy var savedQuotesCoordinator: Coordinator = {
		let controller = navigationController(title: "Saved", image: UIImage(named: "saved"))
		let coordinator = SavedQuoteCoordinator(navigationController: controller, serviceContainer: serviceContainer)
		coordinator.start()
		return coordinator
	}()
	
	private lazy var memeCoordinator: Coordinator = {
		let controller = navigationController(title: "Memes", image: UIImage(named: "memes"))
		let coordinator = MemeCoordinator(navigationController: controller, serviceContainer: serviceContainer)
		coordinator.start()
		return coordinator
	}()
	
	init(tabBarController: UITabBarController, serviceContainer: ServiceContainer) {
		self.tabBarController = tabBarController
		self.serviceContainer = serviceContainer
	}
	
	func start() {
		let viewControllers = [tagCoordinator.navigationController,
							   quoteSearchCoordinator.navigationController,
							   savedQuotesCoordinator.navigationController,
							   memeCoordinator.navigationController]
		tabBarController.setViewControllers(viewControllers, animated: false)
	}
	
	private func navigationController(title: String, image: UIImage?) -> UINavigationController {
		let navigationController = UINavigationController()
		navigationController.tabBarItem.title = title
		navigationController.tabBarItem.image = image
		return navigationController
	}
}
