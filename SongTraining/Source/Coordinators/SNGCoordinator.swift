//
//  SNGCoordinator.swift
//  SongTraining
//
//  Created by William Rena on 6/28/23.
//

import UIKit
import WSRComponents_UIKit

class SNGCoordinator: WSRCoordinatorProtocol {
    var childCoordinators = [WSRCoordinatorProtocol]()
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = SNGSignInViewController.instantiate()
        navigationController?.pushViewController(vc, animated: true)
    }

}
