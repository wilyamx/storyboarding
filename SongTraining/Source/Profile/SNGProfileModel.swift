//
//  SNGProfileModel.swift
//  SongTraining
//
//  Created by William Rena on 7/5/23.
//

import Foundation

struct SNGProfileSetting {
    let image: String?
    let label: String
    
    init(label: String, image: String? = nil) {
        self.image = image
        self.label = label
    }
}
