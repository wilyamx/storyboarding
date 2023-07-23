//
//  SNGNewsDetailViewController.swift
//  SongTraining
//
//  Created by William Rena on 7/6/23.
//

import UIKit

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
        //self.imgvContent.image = UIIma
    }
}
