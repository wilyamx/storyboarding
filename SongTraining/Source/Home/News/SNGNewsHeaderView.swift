//
//  SNGNewsHeaderView.swift
//  SongTraining
//
//  Created by William Rena on 7/6/23.
//

import UIKit

class SNGNewsHeaderView: UIView, WSRNibloadable {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    
    var nextAction: (() -> Void)? = nil
    
    @IBAction func actnNext(_ sender: UIButton) {
        if let action = nextAction {
            action()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
