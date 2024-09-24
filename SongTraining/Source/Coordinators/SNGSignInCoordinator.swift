//
//  SNGSignInCoordinator.swift
//  SongTraining
//
//  Created by William Rena on 7/5/23.
//

import UIKit
import WSRComponents_UIKit

class SNGSignInCoordinator: WSRCoordinatorProtocol {
    var childCoordinators = [WSRCoordinatorProtocol]()
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    // MARK: - Navigations
    
    func switchToLandingPage(forAuthenticatedUser: Bool? = false) {
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        window.rootViewController = SNGTabBarController.tabController(forAuthenticatedUser: forAuthenticatedUser)
    }
    
    func switchToSignIn() {
        guard let window = UIApplication.shared.windows.first else { return }
        
        let vc = SNGSignInViewController.instantiate()
        vc.coordinator = self
        navigationController?.pushViewController(vc, animated: true)
        
        window.rootViewController = navigationController
    }
    
    func signUp() {
        let vc = SNGSignUpViewController.instantiate()
        vc.coordinator = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func skip() {
        
    }
}
