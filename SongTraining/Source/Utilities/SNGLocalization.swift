//
//  SNGLocalization.swift
//  SongTraining
//
//  Created by William Rena on 7/7/23.
//

import Foundation

struct SNGLocalization {
    
    static func newsDateDisplay(from dateText: String) -> String? {
        // "2022-09-22T08:21:11.330Z"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let date = dateFormatter.date(from: dateText)
        
        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "MMMM d, yyyy"
        
        if let date = date {
            return displayDateFormatter.string(from: date)
        }
        
        return nil
    }
}
