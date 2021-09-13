//
//  UIViewController+Extension.swift
//  SeoulPrice
//
//  Created by jongchulshin on 2021/08/26.
//

import UIKit

extension UIViewController {

    public func addViewController(_ viewController: UIViewController) {
        self.addChild(viewController)
        self.view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    public func removeViewController(_ viewController: UIViewController) {
        viewController.willMove(toParent: self)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
}
