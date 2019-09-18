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
    
    var window: UIWindow?
    
    private let serviceContainer = ServiceContainer()
    private let initialViewController = UITabBarController()
    private lazy var initialCoordinator: Coordinator = {
        return MainCoordinator(tabBarController: initialViewController, serviceContainer: serviceContainer)
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        startInitialCoordinator()
        return true
    }
    
    // MARK: - Private
    
    private func startInitialCoordinator() {
        initialCoordinator.start()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
}
