//
//  FeedbackViewCell.swift
//  SupportClient
//
//  Created by Cameron Russell on 2/15/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

class FeedbackTableViewCell: UITableViewCell {
    
    static let reuseID: String = "FeedbackTableViewCell"
    
    private let subtitleLabel = UILabel()
    private let titleLabel = UILabel()
    private let unreadImageView = UIImageView()
    
    private let padding: CGFloat = 24

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUnreadImage()
        setUpTitle()
        setUpSubtitle()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUnreadImage() {
        unreadImageView.translatesAutoresizingMaskIntoConstraints = false
        unreadImageView.image = UIImage(named: "unreadDot")
        unreadImageView.contentMode = .scaleAspectFit
        unreadImageView.isHidden = true
        contentView.addSubview(unreadImageView)
    }
    
    func setUpTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = ._17RobotoMedium
        titleLabel.textColor = .titleColor
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(titleLabel)
    }
    
    func setUpSubtitle() {
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = ._13RobotoMedium
        subtitleLabel.textColor = .subtitleColor
        subtitleLabel.numberOfLines = 1
        subtitleLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(subtitleLabel)
    }
    
    func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3 * padding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2 * padding),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
        ])
        
        NSLayoutConstraint.activate([
            unreadImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            unreadImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])

    }
    
    func configure(feedback: Feedback) {
        titleLabel.text = feedback.title
        subtitleLabel.text = feedback.message
        unreadImageView.isHidden = feedback.hasRead
    }
    
}
