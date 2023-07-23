//
//  SNGActivityIndicator.swift
//  SongTraining
//
//  Created by William Rena on 7/3/23.
//

import UIKit

class SNGActivityIndicatorContainerView: UIView {
    
    // MARK: - Private Method
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.alpha = 0.5
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let viewActivityIndicator: SNGActivityIndicator = {
        let activityIndicator = SNGActivityIndicator()
        activityIndicator.image = UIImage(named: "Loading")
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    public func show(on containerView: UIView) {
        self.frame = containerView.bounds
        
        self.backgroundView.frame = containerView.bounds
        self.backgroundView.isUserInteractionEnabled = true
        containerView.addSubview(self.backgroundView)
                
        let width = 100.0
        let xPosition = (self.frame.width / 2.0) - (width / 2.0)
        let yPosition = (self.frame.height / 2.0) - (width / 2.0)
        self.viewActivityIndicator.frame = CGRect(x: xPosition,
                                                  y: yPosition,
                                                  width: width,
                                                  height: width)
        self.viewActivityIndicator.startAnimating()
        containerView.addSubview(self.viewActivityIndicator)
    }
    
    public func hide() {
        self.viewActivityIndicator.stopAnimating()
        self.viewActivityIndicator.removeFromSuperview()
        
        self.backgroundView.removeFromSuperview()
    }
    
}

class SNGActivityIndicator: UIImageView {

    override func startAnimating() {
        isHidden = false
        rotate()
    }

    override func stopAnimating() {
        isHidden = true
        removeRotation()
    }

    private func rotate() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        layer.add(rotation, forKey: "rotationAnimation")
    }

    private func removeRotation() {
        layer.removeAnimation(forKey: "rotationAnimation")
    }
}



