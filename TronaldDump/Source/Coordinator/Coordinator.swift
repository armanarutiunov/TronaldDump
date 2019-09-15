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

class MainCoordinator: UISearchContainerViewController {
	let navigationController = UINavigationController()
	var serviceContainer: ServiceContainer
	
	private let tabBarController: UITabBarController
	
	private lazy var tagCoordinator: Coordinator = {
		let tagNavigationController = UINavigationController()
		let tagCoordinator = TagCoordinator(navigationController: tagNavigationController, serviceContainer: serviceContainer)
		tagCoordinator.start()
		return tagCoordinator
	}()
	
	private lazy var quoteSearchCoordinator: Coordinator = {
		let navigationController = UINavigationController()
		let coordinator = QuoteSearchCoordinator(navigationController: navigationController, serviceContainer: serviceContainer)
		coordinator.start()
		return coordinator
	}()
	
	private lazy var savedQuotesCoordinator: Coordinator = {
		let navigationController = UINavigationController()
		let coordinator = SavedQuoteCoordinator(navigationController: navigationController, serviceContainer: serviceContainer)
		coordinator.start()
		return coordinator
	}()
	
	private lazy var memeCoordinator: Coordinator = {
		let navigationController = UINavigationController()
		let coordinator = MemeCoordinator(navigationController: navigationController, serviceContainer: serviceContainer)
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
}
