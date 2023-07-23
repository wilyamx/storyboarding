//
//  WSRNibLoadable.swift
//  SongTraining
//
//  Created by William Rena on 6/28/23.
//

import UIKit

public protocol WSRNibloadable {
    static func nib() -> UINib
}

extension WSRNibloadable where Self: UIView {

    public static func nib() -> UINib {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: String(describing: self), bundle: bundle)
        return nib
    }

    public static func viewFromNib(owner: Any? = nil) -> Self? {
        let bundle = Bundle(for: self)
        let views = bundle.loadNibNamed(String(describing: self), owner: owner, options: nil)
        guard let view = views?.first as? Self else {
            logger.error(message: "Could not load a view of type \(NSStringFromClass(Self.self)). Is the view class correctly set in interface builder to the type you are expecting?")
            return nil
        }
        return view
    }

    public static func viewFromNib2(owner: Any?) -> UIView {
        let bundle = Bundle.main
        let view = (bundle.loadNibNamed(String(describing: self),
                                        owner: owner,
                                        options: nil)?.first as? UIView)!
        return view
    }
    
    public static func bundle() -> Bundle {
        return Bundle(for: self)
    }
}
