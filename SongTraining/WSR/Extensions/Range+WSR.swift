//
//  Range+WSR.swift
//  SongTraining
//
//  Created by William Rena on 6/28/23.
//

import UIKit

extension Range where Bound == String.Index {
    
    // https://stackoverflow.com/questions/36043006/tap-on-a-part-of-text-of-uilabel
    
    var nsRange:NSRange {
        return NSRange(location: self.lowerBound.encodedOffset,
                   length: self.upperBound.encodedOffset -
                    self.lowerBound.encodedOffset)
    }
    
}

