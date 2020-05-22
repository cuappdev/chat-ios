//
//  UIWindow+Extensions.swift
//  SupportClient
//
//  Created by Cameron Russell on 5/11/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

extension UIWindow {
    
    override open var canBecomeFirstResponder: Bool {
        return true
    }

    open override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake, shouldShowAlert() {
            motionShakeAlert()
        }
    }
    
    /**
     Displays multi-section alert that allows user to submit feedback
     */
    func motionShakeAlert() {
        let alert = UIAlertController(title: "Add new tag", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(
            title: "Customer Service",
            style: .default,
            handler: nil
        ))
        
        alert.addAction(UIAlertAction(
            title: "Report a Bug",
            style: .default,
            handler: nil
        ))
        
        alert.addAction(UIAlertAction(
            title: "Request a Feature",
            style: .default,
            handler: nil
        ))

        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .destructive,
            handler: nil
        ))
        
        if let root = self.rootViewController {
            root.present(alert, animated: true, completion: nil)
        }
    }
    
    /**
     Returns the current presenting view controller
     */
    private func shouldShowAlert() -> Bool {
        var root = self.rootViewController
        while true {
            if let presented = root?.presentedViewController {
                root = presented
            } else if let nav = root as? UINavigationController {
                root = nav.visibleViewController
            } else if let tab = root as? UITabBarController {
                root = tab.selectedViewController
            } else {
                break
            }
        }
        return root?.isKind(of: ViewController.self) ?? false || root?.isKind(of: FeedbackViewController.self) ?? false
    }
    
}
