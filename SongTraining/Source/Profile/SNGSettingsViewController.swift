//
//  SNGSettingsViewController.swift
//  SongTraining
//
//  Created by William Rena on 7/5/23.
//

import UIKit

class SNGSettingsViewController: SNGViewController, WSRStoryboarded {

    weak var coordinator: SNGProfileCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"
        self.sngAddDummyIndicator(title: self.title!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
