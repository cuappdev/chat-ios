//
//  CustomerServiceTableViewCell.swift
//  SupportClient
//
//  Created by Yana Sang on 5/8/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

class CustomerServiceTableViewCell: UITableViewCell {

    static let reuseIdentifier = "customerServiceTableViewCell"

    private let messageLabel = UILabel()
    private let nameLabel = UILabel()
    private let profileBackground = UIView()
    private let profileImageView = UIImageView()
    private let timeLabel = UILabel()
    private let unreadImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupConstraints()
    }

    func setupViews() {
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        nameLabel.textColor = ._textGray
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)

        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        timeLabel.textColor = ._textGray
        timeLabel.textAlignment = .right
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeLabel)

        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        messageLabel.textColor = ._textBlack
        messageLabel.numberOfLines = 2
        messageLabel.lineBreakMode = .byTruncatingTail
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageLabel)

        profileBackground.layer.cornerRadius = 22
        profileBackground.layer.masksToBounds = true
        profileBackground.backgroundColor = ._mediumGray
        profileBackground.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profileBackground)

        profileImageView.image = UIImage(named: "sloth")
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profileImageView)

        unreadImageView.image = UIImage(named: "unreadDot")
        unreadImageView.contentMode = .scaleAspectFit
        unreadImageView.isHidden = true
        unreadImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(unreadImageView)
    }

    func setupConstraints() {
        let padding: CGFloat = 15
        let profileBackgroundSize: CGFloat = 44
        let profileImageSize: CGFloat = 32
        let unreadImageViewSize: CGFloat = 8

        NSLayoutConstraint.activate([
            profileBackground.heightAnchor.constraint(equalToConstant: profileBackgroundSize),
            profileBackground.widthAnchor.constraint(equalToConstant: profileBackgroundSize),
            profileBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            profileBackground.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        ])

        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: profileImageSize),
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageSize),
            profileImageView.centerXAnchor.constraint(equalTo: profileBackground.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: profileBackground.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
        ])

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: timeLabel.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -padding)
        ])

        NSLayoutConstraint.activate([
            unreadImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            unreadImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            unreadImageView.heightAnchor.constraint(equalToConstant: unreadImageViewSize),
            unreadImageView.widthAnchor.constraint(equalToConstant: unreadImageViewSize)
        ])

        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: unreadImageView.leadingAnchor, constant: -8),
            messageLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8)
        ])
    }

    func configure(for item: Feedback) {
        nameLabel.text = item.adminRep?.name
        timeLabel.text = item.createdAt.convertToTimestamp()
        messageLabel.text = item.message
        unreadImageView.isHidden = item.hasRead ?? false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
