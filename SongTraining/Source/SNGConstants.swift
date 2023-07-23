//
//  SNGConstants.swift
//  SongTraining
//
//  Created by William Rena on 6/28/23.
//

import UIKit

enum SNGStoryboard: String {
    case signIn = "SNGSignInViewController"
    case signUp = "SNGSignUpViewController"
}

extension UIColor {
    static var sngGray: UIColor {
        return UIColor(named: "Gray")!
    }
    
    static var sngGreen: UIColor {
        return UIColor(named: "Green")!
    }
    
    static var sngRed: UIColor {
        return UIColor(named: "Red")!
    }
    
    static var sngBrandColor: UIColor {
        return UIColor(named: "Green")!
    }
    
    static var sngSecondaryColor: UIColor {
        return UIColor(named: "Secondary")!
    }
    
    static var sngDisabledColor: UIColor {
        return UIColor(named: "Gray")!
    }
    
    static var sngSuccessColor: UIColor {
        return UIColor(named: "Success")!
    }
    
    static var sngInformationColor: UIColor {
        return UIColor(named: "Information")!
    }
    
    static var sngWarningColor: UIColor {
        return UIColor(named: "Warning")!
    }
    
    static var sngErrorColor: UIColor {
        return UIColor(named: "Error")!
    }
}

enum SNGSegue: String {
    case newsList = "newsListSegue"
    case newsDetail = "newsDetailSegue"
    case signUp = "signUpSegue"
}
