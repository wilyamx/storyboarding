//
//  SNGViewController.swift
//  SongTraining
//
//  Created by William Rena on 6/28/23.
//

import UIKit
import Reachability
import WSRUtils

class SNGViewController: UIViewController, WSRNetworkObserverDelegate {
    
    private let viewActivityIndicator: SNGActivityIndicatorContainerView = {
        let activityIndicator = SNGActivityIndicatorContainerView()
        return activityIndicator
    }()
    
    var errorAlert: SNGErrorAlertContainerView?
    var reachability: Reachability?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Public Methods
    
    public func showActivityIndicator() {
        viewActivityIndicator.show(on: self.view)
    }
    
    public func hideActivityIndicator() {
        viewActivityIndicator.hide()
    }
    
}

protocol SNGTabBarContent {
    func sngNavigationBarSetup()
}

extension SNGTabBarContent where Self: UIViewController {
    func sngNavigationBarSetup() {
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
        
        let logo = UIImage(named: "SmallBrandLogo")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        
        self.navigationItem.titleView = imageView
        self.navigationItem.largeTitleDisplayMode = .never
    }

}

extension UIViewController {
    func sngAddDummyIndicator(title: String) {
        let width = 110.0
        let height = 90.0
        let dummyIndicator = SNGDummyView.viewFromNib()
        dummyIndicator?.lblTitle.text = title
        
        let xPosition = (self.view.bounds.width / 2.0) - (width / 2.0)
        let yPosition = (self.view.bounds.height / 2.0) - (height / 2.0)
        
        dummyIndicator?.frame = CGRect(x: xPosition,
                                       y: yPosition,
                                       width: width,
                                       height: height)
        
        self.view.addSubview(dummyIndicator!)
    }
    
    func sngNavigationBarWithLogo(withLineSeparator: Bool? = true) {
        let logo = UIImage(named: "SmallBrandLogo")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        
        self.navigationItem.titleView = imageView
        self.navigationItem.largeTitleDisplayMode = .never
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        if let withLineSeparator = withLineSeparator, !withLineSeparator {
            self.navigationController?.navigationBar.addLineSeparator(color: UIColor.white)
        }
    }
}

extension SNGViewController: SNGErrorAlertViewDelegate {
    func didClose(alert: SNGErrorAlertView, type: SNGErrorAlertType) {
        if type == SNGErrorAlertType.noInternetConnection {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl,
                                          completionHandler: { (success) in
                    wsrLogger.info(message: "Settings opened: \(success)")
                })
            }
        }
        self.errorAlert = nil
        NotificationCenter.default.post(name: .noResultsModalDidClose, object: false)
        wsrLogger.info(message: "Error alert message closed!")
    }
}

extension SNGViewController: WSRNetworkActionDelegate {
    func reachabilityChanged(_ isReachable: Bool) {
        wsrLogger.info(message: "isReachable? \(isReachable)")
        
        if isReachable {
            DispatchQueue.main.async {
                self.errorAlert?.close()
                self.errorAlert = nil
            }
            
        }
        else {
            if errorAlert == nil {
                DispatchQueue.main.async {
                    self.errorAlert = SNGErrorAlertContainerView()
                    self.errorAlert?.showAlert(with: SNGErrorAlertType.noInternetConnection,
                                               on: self,
                                               withDelegate: self)
                }
            }
        }
    }
}
