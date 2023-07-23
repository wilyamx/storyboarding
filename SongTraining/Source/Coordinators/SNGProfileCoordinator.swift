//
//  SNGProfileCoordinator.swift
//  SongTraining
//
//  Created by William Rena on 7/5/23.
//

import UIKit

class SNGProfileCoordinator: WSRCoordinatorProtocol {
    var childCoordinators = [WSRCoordinatorProtocol]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    // MARK: - Navigations
    
    func profileDetails() {
        let vc = SNGProfileDetailsViewController.instantiate()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func settings() {
        let vc = SNGSettingsViewController.instantiate()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func support() {
        let vc = SNGSupportViewController.instantiate()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func signUp() {
        let vc = SNGSignUpViewController.instantiate()
        vc.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func switchToSignIn() {
        guard let window = UIApplication.shared.windows.first else { return }
        guard let sceneDelegate = window.windowScene?.delegate as? SceneDelegate else { return }
        
        sceneDelegate.navigationVC = UINavigationController()
        sceneDelegate.coordinator = SNGSignInCoordinator(navigationController: sceneDelegate.navigationVC!)
        sceneDelegate.coordinator?.start()
        
        let vc = SNGSignInViewController.instantiate()
        vc.coordinator = sceneDelegate.coordinator
        sceneDelegate.navigationVC?.pushViewController(vc, animated: true)
        
        window.rootViewController = sceneDelegate.navigationVC
    }
}
