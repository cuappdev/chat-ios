//
//  NoMessageView.swift
//  SupportClient
//
//  Created by Cameron Russell on 3/11/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

/**
 UIView for when user has no current two-way communication channels open
 */
class NoMessageView: UIView {
            
    private let feedbackLabel = UILabel()
    private let newConversationButton = UIButton()
    private var onPress: (() -> Void)?
    
    override var intrinsicContentSize: CGSize {
        return UIScreen.main.bounds.size
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(onPress: @escaping () -> Void) {
        super.init(frame: .zero)
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
            NSAttributedString.Key.foregroundColor: UIColor._darkGray
        ]
        let attributedText = NSMutableAttributedString(string: title, attributes: titleAttributes)
        let subtitleAttributes = [
            NSAttributedString.Key.font: UIFont._13RobotoRegular!,
            NSAttributedString.Key.foregroundColor: UIColor._textGray
        ]
        attributedText.append(NSAttributedString(string: subtitle, attributes: subtitleAttributes))
        feedbackLabel.attributedText = attributedText
        feedbackLabel.sizeToFit()
        addSubview(feedbackLabel)
    }
    
    func setupNewConversationButton() {
        newConversationButton.translatesAutoresizingMaskIntoConstraints = false
        newConversationButton.setTitle("Start Conversation", for: .normal)
        newConversationButton.backgroundColor = UIColor._themeColor
        newConversationButton.titleLabel?.font = UIFont._17RobotoMedium
        newConversationButton.layer.cornerRadius = 22
        newConversationButton.addTarget(self, action: #selector(newConversationBtnPressed), for: .touchUpInside)
        addSubview(newConversationButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            feedbackLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            feedbackLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -60)
        ])
        NSLayoutConstraint.activate([
            newConversationButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            newConversationButton.topAnchor.constraint(equalTo: feedbackLabel.bottomAnchor, constant: UIScreen.main.bounds.height / 2.5),
            newConversationButton.widthAnchor.constraint(equalToConstant: 220),
            newConversationButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func setupAnimation() {
        newConversationButton.alpha = 0
        feedbackLabel.alpha = 0
        UIView.transition(with: self, duration: 0.75, animations: {
            self.newConversationButton.alpha = 1
            self.feedbackLabel.alpha = 1
        }, completion: nil)
    }

    @objc func newConversationBtnPressed() {
        onPress?()
    }
    
}
