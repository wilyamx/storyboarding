//
//  SNGProfileHeaderView.swift
//  SongTraining
//
//  Created by William Rena on 7/5/23.
//

import UIKit

class SNGProfileHeaderView: UIView, WSRNibloadable {

    @IBOutlet weak var imgvAvatar: UIImageView!
    @IBOutlet weak var lblUser: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblUser.font = UIFont.preferredFont(forTextStyle: .body)
        imgvAvatar.layer.cornerRadius = imgvAvatar.frame.size.width / 2.0
    }
    
    public func updateUserDisplay(headline: String, subheadline: String) {
        let userText = "\(headline)\n\(subheadline)"
        let userBoldText = "\(subheadline)"
       
        if let range = userText.range(of: userBoldText)?.nsRange {
            let boldAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
            
            let attributedString = NSMutableAttributedString(string: userText)
            attributedString.addAttributes(boldAttributes, range: range)
            
            self.lblUser.attributedText = attributedString
        }
    }
    
    public func updateUserDisplay() {
        let userText = "Hello there, Guest!"
        let userBoldText = userText
       
        if let range = userText.range(of: userBoldText)?.nsRange {
            let boldAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
            
            let attributedString = NSMutableAttributedString(string: userText)
            attributedString.addAttributes(boldAttributes, range: range)
            
            self.lblUser.attributedText = attributedString
        }
    }
}
