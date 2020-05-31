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
    
    private let bannerMessage = UILabel()
    private let bannerTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewProperties()
        setupBannerLabels()
        setupConstraints()
    }

    /**
     Banner text must be set up using this convenience initializer
     */
    convenience init(backgroundColor: UIColor, title: String, message: String) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        bannerTitle.text = title
        bannerMessage.text = message
    }

    func setupViewProperties() {
        self.translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(hide(_:)))
        swipeGesture.direction = .up
        addGestureRecognizer(swipeGesture)
    }

    func setupBannerLabels() {
        bannerTitle.translatesAutoresizingMaskIntoConstraints = false
        bannerTitle.textColor = .white
        bannerTitle.font = UIFont.boldSystemFont(ofSize: 14)
        addSubview(bannerTitle)

        bannerMessage.translatesAutoresizingMaskIntoConstraints = false
        bannerMessage.textColor = .white
        bannerMessage.font = UIFont.systemFont(ofSize: 12)
        addSubview(bannerMessage)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            bannerTitle.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            bannerTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])

        NSLayoutConstraint.activate([
            bannerMessage.topAnchor.constraint(equalTo: bannerTitle.bottomAnchor, constant: 8),
            bannerMessage.leadingAnchor.constraint(equalTo: bannerTitle.leadingAnchor)
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
            withDuration: 1.5,
            animations: {
                self.center.y = 100
            },
            completion: { finished in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.hide()
                }
            }
        )
    }
    
    /**
     Dismisses the presenting banner view
     */
    @objc func hide(_ sender: UISwipeGestureRecognizer? = nil) {
        let duration = sender != nil ? 0.1 : 2.0 
        UIView.animate(
            withDuration: duration,
            animations: {
                let padding = UIApplication.shared.windows[0].safeAreaInsets.top
                self.center.y = -self.frame.height / 2 - padding
            },
            completion: { finished in
                self.removeFromSuperview()
            }
        )
    }
    
}
