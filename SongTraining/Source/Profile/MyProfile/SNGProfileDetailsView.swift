//
//  SNGProfileDetailsView.swift
//  SongTraining
//
//  Created by William Rena on 7/6/23.
//

import UIKit

class SNGProfileDetailsView: UIView, WSRNibloadable {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var imgvAvatar: UIImageView!
    
    var allowEditing: Bool = false {
        didSet {
            txtFirstName.isUserInteractionEnabled = allowEditing
            txtLastName.isUserInteractionEnabled = allowEditing
            txtEmail.isUserInteractionEnabled = allowEditing
            txtUsername.isUserInteractionEnabled = allowEditing
        }
    }
    
    @IBAction func actnEditProfile(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgvAvatar.layer.cornerRadius = imgvAvatar.frame.size.width / 2.0
        
        [txtFirstName, txtLastName, txtEmail, txtUsername].forEach { textField in
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.secondarySystemFill.cgColor
            textField.layer.cornerRadius = 5.0
        }
        
        let buttonText = "Edit Profile"
        if let range = buttonText.range(of: buttonText)?.nsRange {
            let boldAttribute = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13)]
            
            let attributedString = NSMutableAttributedString(string: buttonText)
            attributedString.addAttributes(boldAttribute, range: range)
            
            btnEditProfile.setAttributedTitle(attributedString, for: .disabled)
        }
        btnEditProfile.isEnabled = false
    }
    
}
