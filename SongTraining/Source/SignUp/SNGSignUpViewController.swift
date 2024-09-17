//
//  SNGSignUpViewController.swift
//  SongTraining
//
//  Created by William Rena on 6/28/23.
//

import UIKit
import WSRComponents

class SNGSignUpViewController: SNGViewController, WSRStoryboarded {

    weak var coordinator: SNGSignInCoordinator?
    
    @IBAction func actnRegisterSuccess(_ sender: UIButton) {
        if let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            window.rootViewController = SNGTabBarController.tabController()
        }
    }
    
    @IBAction func actnBack(_ sender: UIButton) {
        if let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let vc = storyboard.instantiateViewController(withIdentifier: SNGStoryboard.signIn.rawValue)
            
            window.rootViewController = vc
        }
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sngAddDummyIndicator(title: "Sign up")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
