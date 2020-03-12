//
//  EmptyTableViewCustomView.swift
//  SupportClient
//
//  Created by Cameron Russell on 3/11/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

class NoMessageView: CustomView {
            
    private let feedbackLabel = UILabel()
    private let newConversationButton = UIButton()
    @objc private var onPress: (() -> Void)?
    
    var view: CustomView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(onPress: @escaping () -> Void) {
        self.init()
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        view = CustomView(width: width, height: height)
        self.onPress = onPress
        setupFeedbackLabel()
        setupNewConversationButton()
        setupConstraints()
        setupAnimation()
    }
    
    func setupFeedbackLabel() {
        // Create ParagraphStyle to format label text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 10
        // Set up feedbackLabel
        feedbackLabel.translatesAutoresizingMaskIntoConstraints = false
        feedbackLabel.lineBreakMode = .byWordWrapping
        feedbackLabel.numberOfLines = 0
        let title = "No Feedback Yet\n"
        let subtitle = "See feedback conversations here"
        let titleAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont._17RobotoMedium!,
            .paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: UIColor.titleColor
        ]
        let attributedText = NSMutableAttributedString(string: title, attributes: titleAttributes)
        let subtitleAttributes = [
            NSAttributedString.Key.font: UIFont._13RobotoRegular!,
            NSAttributedString.Key.foregroundColor: UIColor.subtitleColor
        ]
        attributedText.append(NSAttributedString(string: subtitle, attributes: subtitleAttributes))
        feedbackLabel.attributedText = attributedText
        feedbackLabel.sizeToFit()
        view.addSubview(feedbackLabel)
    }
    
    func setupNewConversationButton() {
        newConversationButton.translatesAutoresizingMaskIntoConstraints = false
        newConversationButton.setTitle("Start Conversation", for: .normal)
        newConversationButton.backgroundColor = UIColor.themeColor
        newConversationButton.titleLabel?.font = UIFont._17RobotoMedium
        newConversationButton.layer.cornerRadius = 22
        newConversationButton.addTarget(self, action: #selector(getter: onPress), for: .touchUpInside)
        view.addSubview(newConversationButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            feedbackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            feedbackLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -60)
        ])
        NSLayoutConstraint.activate([
            newConversationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newConversationButton.topAnchor.constraint(equalTo: feedbackLabel.bottomAnchor, constant: UIScreen.main.bounds.height / 2.5),
            newConversationButton.widthAnchor.constraint(equalToConstant: 220),
            newConversationButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func setupAnimation() {
        newConversationButton.alpha = 0
        feedbackLabel.alpha = 0
        UIView.transition(with: view, duration: 0.75, animations: {
            self.newConversationButton.alpha = 1
            self.feedbackLabel.alpha = 1
        }, completion: nil)
    }
    
}
