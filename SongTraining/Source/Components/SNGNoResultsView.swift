//
//  SNGNoResultsView.swift
//  SongTraining
//
//  Created by William Rena on 7/5/23.
//

import UIKit

class SNGNoResultsView: UIView, WSRNibloadable {
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgvIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func lighterTheme() {
        self.imgvIcon.tintColor = UIColor.sngGray
        self.lblTitle.textColor = UIColor.sngGray
        self.lblDescription.textColor = UIColor.sngGray
        
        self.backgroundColor = UIColor.secondarySystemBackground
    }
}
