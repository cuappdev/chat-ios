//
//  UIView+Extensions.swift
//  SupportClient
//
//  Created by Cameron Russell on 4/26/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

extension UIView {
    
    func fadeIn(_ view: UIView) {
        DispatchQueue.main.async {
            UIView.animate(
                withDuration: 5.0,
                delay: 0.0,
                usingSpringWithDamping: 0.03,
                initialSpringVelocity: 0.9,
                options: [],
                animations: {
                    self.translatesAutoresizingMaskIntoConstraints = false
                    view.addSubview(self)
                    NSLayoutConstraint.activate([
                        self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
                        self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                        self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5)
                    ])
                },
                completion: { didFinish in
                    
                }
            )
        }
    }
    
    func fadeOut() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.0) {
                self.removeFromSuperview()
            }
        }
    }
    
}
