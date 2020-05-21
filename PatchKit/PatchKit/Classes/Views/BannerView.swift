//
//  ConfirmationBanner.swift
//  SupportClient
//
//  Created by Cameron Russell on 4/26/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit


/**
 A custom BannerView Class
 This displays a notification from the top of the screen with the
 message: "Thank you for your feedback"
 */
class BannerView: UIView {
    
    private let bannerTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupBannerTextField()
        setupConstraints()
    }
    
    func setupBannerTextField() {
        bannerTextField.translatesAutoresizingMaskIntoConstraints = false
        bannerTextField.layer.cornerRadius = 5
        bannerTextField.backgroundColor = ._green
        bannerTextField.text = "Thank you for your feedback"
        bannerTextField.font = UIFont.systemFont(ofSize: 14)
        bannerTextField.textAlignment = .center
        addSubview(bannerTextField)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            bannerTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            bannerTextField.topAnchor.constraint(equalTo: topAnchor),
            bannerTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Reveals the success banner view.
     Animation lasts a total of 5 seconds
     */
    func show() {
        UIView.animate(
            withDuration: 3.0,
            animations: {
                self.center.y = 100
            },
            completion: { finished in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.hide()
                }
            }
        )
    }
    
    /**
     Dismisses the presenting banner view
     */
    func hide() {
        UIView.animate(
            withDuration: 2.0,
            animations: {
                self.center.y = -self.frame.height / 2
            },
            completion: { finished in
                self.removeFromSuperview()
            }
        )
    }
    
}
