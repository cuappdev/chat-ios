//
//  BugsRequestsTableViewCell.swift
//  SupportClient
//
//  Created by Yana Sang on 5/8/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

class BugsRequestsTableViewCell: UITableViewCell {

    static let reuseIdentifier = "bugsRequestsTableViewCell"

    private let tagsLabel = UILabel()
    private let timeLabel = UILabel()
    private let messageLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupTagsLabel()
        setupTimesLabel()
        setupMessageLabel()
        setupConstraints()
    }

    func setupTagsLabel() {
        tagsLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        tagsLabel.textColor = ._textGray
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tagsLabel)
    }

    func setupTimesLabel() {
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        timeLabel.textColor = ._textGray
        timeLabel.textAlignment = .right
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeLabel)
    }

    func setupMessageLabel() {
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        messageLabel.textColor = ._textBlack
        messageLabel.numberOfLines = 2
        messageLabel.lineBreakMode = .byTruncatingTail
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageLabel)
    }

    func setupConstraints() {
        let padding: CGFloat = 15

        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
        ])

        NSLayoutConstraint.activate([
            tagsLabel.topAnchor.constraint(equalTo: timeLabel.topAnchor),
            tagsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            tagsLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -padding)
        ])

        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            messageLabel.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 8)
        ])
    }

    func configure(for item: Feedback) {
        tagsLabel.text = item.tags.isEmpty
            ? item.type.rawValue
            : item.type.rawValue + "    " + item.tags.joined(separator: "    ")
        timeLabel.text = item.createdAt.convertToTimestamp()
        messageLabel.text = item.message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
