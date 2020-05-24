//
//  UIViewController+Extensions.swift
//  SupportClient
//
//  Created by Omar Rasheed on 5/20/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

extension UIViewController {

    func removeBottomOfNavBar() {
        navigationController?.navigationBar.layer.shadowOpacity = 0
        navigationController?.navigationBar.layer.shadowColor = UIColor._mediumGray.cgColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    func addBottomOfNavBar() {
        navigationController?.navigationBar.layer.shadowOpacity = 0.5
        navigationController?.navigationBar.layer.shadowColor = UIColor._mediumGray.cgColor
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    func setupBackButton() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "back", in: PatchKitImages.resourceBundle, compatibleWith: nil)?.withTintColor(.black),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
    }
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }

}
