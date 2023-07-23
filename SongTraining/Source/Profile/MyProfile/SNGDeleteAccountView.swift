//
//  SNGDeleteAccountView.swift
//  SongTraining
//
//  Created by William Rena on 7/6/23.
//

import UIKit

class SNGDeleteAccountView: UIView, WSRNibloadable {
    
    @IBOutlet weak var btnDeleteAccount: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let buttonText = "Delete my Account"
        if let range = buttonText.range(of: buttonText)?.nsRange {
            let boldAttribute = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13)]
            
            let attributedString = NSMutableAttributedString(string: buttonText)
            attributedString.addAttributes(boldAttribute, range: range)
            
            btnDeleteAccount.setAttributedTitle(attributedString, for: .disabled)
        }
        btnDeleteAccount.isEnabled = false
    }
}
