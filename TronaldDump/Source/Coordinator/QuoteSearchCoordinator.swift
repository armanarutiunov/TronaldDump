//
//  QuoteSearchCoordinator.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 15.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import UIKit

class QuoteSearchCoordinator: Coordinator {
    let navigationController: UINavigationController
    var serviceContainer: ServiceContainer
    
    init(navigationController: UINavigationController, serviceContainer: ServiceContainer) {
        self.navigationController = navigationController
        self.serviceContainer = serviceContainer
    }
    
    func start() {
        let viewModel = ConcreteQuoteListViewModel(tagService: serviceContainer.tagService, tagTitle: "Search", isSearchEnabled: true)
        let viewController = QuoteListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
}
