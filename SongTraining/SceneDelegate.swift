//
//  SceneDelegate.swift
//  SongTraining
//
//  Created by William Rena on 6/28/23.
//

import UIKit
import Reachability
import IQKeyboardManagerSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: SNGSignInCoordinator?
    var navigationVC: UINavigationController?
    
    let viewModel = SNGSignInViewModel()
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // handle textfields so it is always on the top of the keyboard
        IQKeyboardManager.shared.enable = true
        
        self.navigationVC = UINavigationController()
        self.coordinator = SNGSignInCoordinator(navigationController: navigationVC!)
        self.coordinator?.start()
        
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()

        self.setupBinders()
        viewModel.checkForLoginUser()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        
        self.viewModel.deleteAllPersistentData()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate {
    private func setupBinders() {
        self.viewModel.isLoggedIn.bind { [weak self] value in
            if value {
                DispatchQueue.main.async {
                    self?.coordinator?.switchToLandingPage(forAuthenticatedUser: self?.viewModel.isAuthenticatedUser())
                }
            }
            else {
                DispatchQueue.main.async {
                    self?.coordinator?.switchToSignIn()
                }
            }
        }
    }
    
}
