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
		let navigationController = UINavigationController()
		navigationController.tabBarItem = UITabBarItem(title: "Tags", image: nil, selectedImage: nil)
		let tagCoordinator = TagCoordinator(navigationController: navigationController, serviceContainer: serviceContainer)
		tagCoordinator.start()
		return tagCoordinator
	}()
	
	private lazy var quoteSearchCoordinator: Coordinator = {
		let navigationController = UINavigationController()
		navigationController.tabBarItem = UITabBarItem(title: "Search", image: nil, selectedImage: nil)
		let coordinator = QuoteSearchCoordinator(navigationController: navigationController, serviceContainer: serviceContainer)
		coordinator.start()
		return coordinator
	}()
	
	private lazy var savedQuotesCoordinator: Coordinator = {
		let navigationController = UINavigationController()
		navigationController.tabBarItem = UITabBarItem(title: "Saved", image: nil, selectedImage: nil)
		let coordinator = SavedQuoteCoordinator(navigationController: navigationController, serviceContainer: serviceContainer)
		coordinator.start()
		return coordinator
	}()
	
	private lazy var memeCoordinator: Coordinator = {
		let navigationController = UINavigationController()
		navigationController.tabBarItem = UITabBarItem(title: "Memes", image: nil, selectedImage: nil)
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
