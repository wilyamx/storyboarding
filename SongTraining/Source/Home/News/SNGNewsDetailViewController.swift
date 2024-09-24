//
//  SNGNewsDetailViewController.swift
//  SongTraining
//
//  Created by William Rena on 7/6/23.
//

import UIKit
import WSRComponents_UIKit

class SNGNewsDetailViewController: SNGViewController, WSRStoryboarded {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtvContent: UITextView!
    @IBOutlet weak var imgvContent: UIImageView!
    
    var attributes: SNGPostAttributes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News Article"
        self.updateDisplay()
    }
    
    private func updateDisplay() {
        guard let attributes = attributes else { return }
        
        self.lblDate.text = SNGLocalization.newsDateDisplay(from: attributes.publishedAt)
        self.lblTitle.text = attributes.title
        self.txtvContent.text = attributes.content
        
        if let mediaData = attributes.media?.data.first {
            let imageFormat = mediaData.attributes.formats.medium
            let imageUrlText = imageFormat.url
            
            self.imgvContent.loadData(
                urlText: imageUrlText,
                placeholder: UIImage(named: "PlaceholderNewsDetail")) { image, error in

                if error == nil, let image = image {
                    DispatchQueue.main.async {
                        self.imgvContent.image = image
                    }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        self.imgvContent.image = image
//                    }
                }
            }
        
        }
    }
}
