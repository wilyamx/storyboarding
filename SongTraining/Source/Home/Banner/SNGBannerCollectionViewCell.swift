//
//  SNGBannerCollectionViewCell.swift
//  SongTraining
//
//  Created by William Rena on 7/10/23.
//

import UIKit

class SNGBannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgvBackground: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func updateDisplay(image: UIImage, model: SNGBannerDataModel) {
        imgvBackground.image = image
        imgvBackground.contentMode = .scaleAspectFill
        
        lblTitle.text = model.attributes.title
        lblDescription.text = model.attributes.shortDescription
    }
}
