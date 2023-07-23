//
//  SNGNewsTableViewCell.swift
//  SongTraining
//
//  Created by William Rena on 7/6/23.
//

import UIKit

class SNGNewsTableViewCell: UITableViewCell, WSRNibloadable {

    @IBOutlet weak var imgvNews: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCalendar: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    static var CELL_HEIGHT = 125.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgvNews.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10,
                                                                     left: 20,
                                                                     bottom: 10,
                                                                     right: 20))
        contentView.backgroundColor = UIColor.tertiarySystemFill
        contentView.layer.cornerRadius = 10.0
    }
    
    public func updateDisplay(model: SNGPostModel) {
        lblTitle.text = model.attributes.title
        lblCalendar.text = SNGLocalization.newsDateDisplay(from: model.attributes.publishedAt)
        
        if let mediaData = model.attributes.media?.data.first {
            let imageFormat = mediaData.attributes.formats.small
            let imageUrlText = imageFormat.url.stringWithDomainUrl()
            
            self.imgvNews.loadData(
                urlText: imageUrlText,
                placeholder: UIImage(named: "ImagePlaceholder")) { image, error in
                    
                if error == nil, let image = image {
                    DispatchQueue.main.async {
                        self.imgvNews.image = image
                    }
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        self.imgvNews.image = image
//                    }
                }
            }
        }
    }
}

