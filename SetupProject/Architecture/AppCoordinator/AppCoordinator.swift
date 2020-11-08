//
//  AppCoordinator.swift
//  Skeleton
//
//  Created by Martin Vasilev on 1.08.18.
//  Copyright © 2018 Upnetix. All rights reserved.
//

import Foundation
import NetworkKit
import SFBaseKit
///
class AppCoordinator: Coordinator {
    
    // MARK: Properties
    let window: UIWindow?
    
    // MARK: Coordinator
    init(window: UIWindow?) {
        self.window = window
        super.init()
        
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    override func start() {
        // Start the next coordinator in the heirarchy or the current module rootViewModel
        childCoordinators.first?.start()
    }
    
    // MARK: Scene Management
    
    /// Called when a BaseViewController is loaded (ViewDidLoad:)
    ///
    /// - Parameter sceneViewController: The BaseViewController of the current Scene
    func sceneDidLoad(_ sceneViewController: BaseViewController) {
        Log.info("ViewDidLoad: \(sceneViewController.name)")
    }
    
    /// Called when a BaseViewController will appear (ViewWillAppear:)
    ///
    /// - Parameter sceneViewController: The BaseViewController of the current Scene
    func sceneWillAppear(_ sceneViewController: BaseViewController) {
        Log.info("ViewWillAppear: \(sceneViewController.name)")
    }
    
    /// Called when a BaseViewController will disappear (ViewWillDisappear:)
    ///
    /// - Parameter sceneViewController: The BaseViewController of the current Scene
    func sceneWillDisappear(_ sceneViewController: BaseViewController) {
        Log.info("ViewWillDisappear: \(sceneViewController.name)")
    }
}
