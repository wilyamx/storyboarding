//
//  SNGFavoritesViewController.swift
//  SongTraining
//
//  Created by William Rena on 6/28/23.
//

import UIKit

class SNGFavoritesViewController: SNGViewController, SNGTabBarContent {

    @IBAction func actnSomethingWentWrong(_ sender: UIButton) {
        let errorAlert = SNGErrorAlertContainerView()
        errorAlert.showAlert(with: .connectionTimedOut, on: self, withDelegate: nil)
    }
    
    @IBAction func actnNoInternetConnection(_ sender: UIButton) {
        let errorAlert = SNGErrorAlertContainerView()
        errorAlert.showAlert(with: .noInternetConnection, on: self, withDelegate: nil)
    }
    
    @IBAction func actnConnectionTimeout(_ sender: UIButton) {
        let errorAlert = SNGErrorAlertContainerView()
        errorAlert.showAlert(with: .somethingWentWrong, on: self, withDelegate: nil)
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sngNavigationBarWithLogo(withLineSeparator: false)
        self.sngAddDummyIndicator(title: "Favorites")
    }

}
