//
//  SNGProductsViewController.swift
//  SongTraining
//
//  Created by William Rena on 6/28/23.
//

import UIKit

class SNGProductsViewController: SNGViewController, SNGTabBarContent {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sngNavigationBarWithLogo(withLineSeparator: false)
        self.sngAddDummyIndicator(title: "Products")
    }
    
}
