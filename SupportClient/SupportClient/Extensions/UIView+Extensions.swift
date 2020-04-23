//
//  UIView+Extensions.swift
//  SupportClient
//
//  Created by Cameron Russell on 4/23/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

/**
 Returns the view controller instance presenting current UIView
 */
extension UIView {
    
    func currentViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.currentViewController()
        } else {
            return nil
        }
    }
    
}
