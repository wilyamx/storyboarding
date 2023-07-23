//
//  UIView+WSR.swift
//  SongTraining
//
//  Created by William Rena on 7/5/23.
//

import UIKit

public extension UIView
{
    func addLineSeparator(y: CGFloat? = nil,
                          margin: CGFloat? = nil,
                          color: UIColor? = nil) {
        
        let margin = margin ?? 0
        let y = y ?? self.frame.height
        let color = color ?? UIColor.secondarySystemFill
        
        let frame = CGRectMake(margin, y, self.frame.width - margin, 1.0)
        
        let separatorView = UIView(frame: frame)
        separatorView.backgroundColor = color
        self.addSubview(separatorView)
    }

}
