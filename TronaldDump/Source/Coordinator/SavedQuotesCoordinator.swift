//
//  SavedQuotesCoordinator.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 15.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import UIKit

class SavedQuoteCoordinator: Coordinator {
    let navigationController: UINavigationController
    var serviceContainer: ServiceContainer
    
    init(navigationController: UINavigationController, serviceContainer: ServiceContainer) {
        self.navigationController = navigationController
        self.serviceContainer = serviceContainer
    }
    
    func start() {
        let viewModel = ConcreteSavedQuotesViewModel(tagService: serviceContainer.tagService)
        let viewController = SavedQuotesViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
}
