//
//  AppDelegate.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 12.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	private let appCore = AppCore()
	
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupInitialCoordinator()
        return true
    }

    // MARK: - Private

    private func setupInitialCoordinator() {
        let navigationController = UINavigationController()
        let coordinator = MainCoordinator(navigationController: navigationController, appCore: appCore)
        coordinator.start()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
