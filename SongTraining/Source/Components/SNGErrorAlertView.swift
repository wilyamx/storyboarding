//
//  SNGErrorAlertView.swift
//  SongTraining
//
//  Created by William Rena on 6/28/23.
//

import UIKit

enum SNGErrorAlertType: String {
    case somethingWentWrong
    case connectionTimedOut
    case noInternetConnection
    
    func getIcon() -> UIImage {
        switch self {
        case .somethingWentWrong:
            return UIImage(systemName: "exclamationmark")!
        case .connectionTimedOut:
            return UIImage(systemName: "exclamationmark")!
        case .noInternetConnection:
            return UIImage(systemName: "wifi.slash")!
        }
    }
    
    func getTitle() -> String {
        switch self {
        case .somethingWentWrong:
            return "Something Went Wrong"
        case .connectionTimedOut:
            return "Connection Timed Out"
        case .noInternetConnection:
            return "No Internet Connection"
        }
    }
    
    func getMessage() -> String {
        switch self {
        case .somethingWentWrong:
            return "Sorry, an error occured while trying to sign in. Please try again later."
        case .connectionTimedOut:
            return "Sorry, an error occured while trying to sign in. Please try again later."
        case .noInternetConnection:
            return "Please try again when your connection is available."
        }
    }
    
    func getActionButtonText() -> String {
        switch self {
        case .somethingWentWrong:
            return "Got it"
        case .connectionTimedOut:
            return "Got it"
        case .noInternetConnection:
            return "Got it"
        }
    }
}

class SNGErrorAlertContainerView: UIView {
    weak var delegate: SNGErrorAlertViewDelegate?
    
    // MARK: - Private Method
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        view.isUserInteractionEnabled = false
        return view
    }()

    private let alertView: SNGErrorAlertView = {
        let view = SNGErrorAlertView.viewFromNib(owner: nil)
        return view!
    }()
    
    // MARK: - Public Method
    
    public func showAlert(with type: SNGErrorAlertType,
                   on viewController: UIViewController,
                          withDelegate delegate: SNGErrorAlertViewDelegate?,
                          _ aTabBarItemDisplay: Bool? = false) {
        
        guard let targetView = viewController.view else { return }
        
        self.delegate = delegate
        
        self.frame = targetView.bounds
        backgroundView.frame = targetView.bounds
        
        //--
        
        let view = alertView
        view.initialize(with: type)
        view.closeAction = {
            self.close()
            self.delegate?.didClose(alert: view)
        }
        
        let padding = 20.0
        let alertContainerHeight = 250.0
        let tabBarHeight = 50.0
        let safeAreaHeight = 35.0
        let alertViewWidth = targetView.bounds.size.width
        
        var yPosition = (targetView.bounds.size.height / 2.0) - (alertContainerHeight / 2.0)
        if let aTabBarItemDisplay = aTabBarItemDisplay, aTabBarItemDisplay  {
            yPosition = targetView.bounds.size.height - tabBarHeight - padding - safeAreaHeight - alertContainerHeight
        }
        
        view.frame = CGRect(x: padding,
                            y: yPosition,
                            width: alertViewWidth - padding * 2.0,
                            height: alertContainerHeight)
        
        targetView.isUserInteractionEnabled = true
        targetView.addSubview(backgroundView)
        
        targetView.addSubview(view)
    }
    
    public func close() {
        self.alertView.removeFromSuperview()
        self.backgroundView.removeFromSuperview()
    }
}

protocol SNGErrorAlertViewDelegate: AnyObject {
    func didClose(alert: SNGErrorAlertView)
}

class SNGErrorAlertView: UIView, WSRNibloadable {
    
    var closeAction: (() -> Void)? = nil
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        view.isUserInteractionEnabled = true
        return view
    }()
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var iconContainerView: UIView!
    @IBOutlet weak var iconBoxView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBAction func actnClose(_ sender: UIButton) {
        if let action = closeAction {
            action()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
    
    private func setUpView() {
        self.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        self.backgroundColor = .white
        self.layer.cornerRadius = 12
        
        self.stackView.backgroundColor = .clear
        self.iconContainerView.backgroundColor = .clear
        
        self.iconBoxView.backgroundColor = UIColor.sngErrorColor
        self.iconBoxView.layer.cornerRadius = 25
        
        self.lblTitle.font = UIFont.boldSystemFont(ofSize: 20)
        self.lblMessage.font = UIFont.preferredFont(forTextStyle: .caption1)
        self.lblMessage.textColor = .secondaryLabel
        
        self.btnClose.tintColor = UIColor.sngErrorColor
    }
    
    public func initialize(with type: SNGErrorAlertType) {
        self.iconImageView.image = type.getIcon()
        self.lblTitle.text = type.getTitle()
        self.lblMessage.text = type.getMessage()
        
        let actionButtonText = type.getActionButtonText()
        let actionButtonFontAttribute = [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        let actionButtonTextRange = NSRange(location: 0, length: actionButtonText.count)
        let actionButtonAttributedString = NSMutableAttributedString(string: actionButtonText)
        actionButtonAttributedString.addAttributes(actionButtonFontAttribute, range: actionButtonTextRange)
        
        self.btnClose.setAttributedTitle(actionButtonAttributedString, for: .normal)
        self.btnClose.setAttributedTitle(actionButtonAttributedString, for: .selected)
    }
    
    
}
