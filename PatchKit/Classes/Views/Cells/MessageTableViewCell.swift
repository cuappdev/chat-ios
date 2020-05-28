//
//  MessageTableViewCell.swift
//  Pods
//
//  Created by Omar Rasheed on 5/24/20.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    static let reuseIdentifier = "MessageTableViewCell"
    
    private let adminImageView = UIImageView()
    private let imagesStackView = ImagesStackView()
    private let messageBubble = UIView()
    private let messageLabel = UILabel()
    private let readLabel = UILabel()
    private let timestampLabel = UILabel()
    
    private let verticalPadding: CGFloat = 6

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupAdminImageView()
        setupMessageBubble()
        setupMessageLabel()
        setupTimestampLabel()
        setupImagesStackView()
        setupReadLabel()
    }
    
    private func setupReadLabel() {
        readLabel.text = "Read"
        readLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        readLabel.textColor = ._textGray
        readLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupImagesStackView() {
        imagesStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupMessageLabel() {
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageBubble.addSubview(messageLabel)
    }
    
    private func setupMessageBubble() {
        messageBubble.layer.cornerRadius = 10
        messageBubble.clipsToBounds = true
        messageBubble.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageBubble)
    }
    
    private func setupAdminImageView() {
        adminImageView.backgroundColor = ._mediumGray
        adminImageView.layer.cornerRadius = 12
        adminImageView.clipsToBounds = true
        adminImageView.contentMode = .scaleAspectFill
        adminImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTimestampLabel() {
        timestampLabel.textColor = ._textGray
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timestampLabel)
    }
    
    private func setupUserMessageConstraints() {
        NSLayoutConstraint.activate([
            messageBubble.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            messageBubble.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 80)
        ])
    }

    private func setupAdminMessageConstraints() {
        NSLayoutConstraint.activate([
            adminImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            adminImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding),
            adminImageView.heightAnchor.constraint(equalToConstant: 24),
            adminImageView.widthAnchor.constraint(equalToConstant: 24)
        ])

        NSLayoutConstraint.activate([
            messageBubble.leadingAnchor.constraint(equalTo: adminImageView.trailingAnchor, constant: 8),
            messageBubble.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -80)
        ])
    }
    
    private func setupMessageLabelConstraints() {
        let messagePadding: CGFloat = 12
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: messageBubble.leadingAnchor, constant: messagePadding),
            messageLabel.trailingAnchor.constraint(equalTo: messageBubble.trailingAnchor, constant: -messagePadding),
            messageLabel.topAnchor.constraint(equalTo: messageBubble.topAnchor, constant: messagePadding),
            messageLabel.bottomAnchor.constraint(equalTo: messageBubble.bottomAnchor, constant: -messagePadding)
        ])
    }
    
    private func setupTimestampLabelConstraints() {
        NSLayoutConstraint.activate([
            timestampLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timestampLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding)
        ])
        
        NSLayoutConstraint.activate([
            messageBubble.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupImagesStackViewConstraints() {
        NSLayoutConstraint.activate([
            imagesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            imagesStackView.topAnchor.constraint(equalTo: messageBubble.bottomAnchor, constant: 8),
        ])
    }
    
    private func setupReadLabelConstraints(topAnchor: NSLayoutYAxisAnchor) {
        NSLayoutConstraint.activate([
            readLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            readLabel.trailingAnchor.constraint(equalTo: messageBubble.trailingAnchor),
            readLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding)
        ])
    }
    
    private func setTimestampLabelText(createdAt: Date) {
        var semiboldedString = ""
        var normalString = " "
        if !Calendar.current.isDateInToday(createdAt) {
            if Calendar.current.isDateInYesterday(createdAt) {
                semiboldedString = "Yesterday"
            } else if createdAt.isBetween(date: Date(), andDate: Date() - 7) {
                semiboldedString = createdAt.formatDateString(format: "E")
            } else {
                semiboldedString = createdAt.formatDateString(format: "MMM d")
                normalString += "| "
            }
        }
        normalString += createdAt.formatDateString(format: "h:mm a")
        timestampLabel.attributedText = NSMutableAttributedString()
            .semibold(semiboldedString, size: 10)
            .normal(normalString, size: 10)
    }

    func configure(for message: Message, showReadLabel: Bool) {
        messageLabel.text = message.content

        if message.isFromAdmin {
            messageBubble.backgroundColor = ._lightGray
            messageLabel.textColor = .black
            contentView.addSubview(adminImageView)
            setupAdminMessageConstraints()
        } else {
            messageBubble.backgroundColor = ._messageBlue
            messageLabel.textColor = .white
            setupUserMessageConstraints()
        }

        setTimestampLabelText(createdAt: message.createdAt)

        if !message.imageUrls.isEmpty {
            imagesStackView.configure(for: message.imageUrls, imageSize: CGSize(width: 88, height: 88), interImageSpacing: 4, numImagesPerRow: 3)
            contentView.addSubview(imagesStackView)
            setupImagesStackViewConstraints()
            if !showReadLabel {
                NSLayoutConstraint.activate([
                    imagesStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding)
                ])
            }
        } else if !showReadLabel {
            NSLayoutConstraint.activate([
                messageBubble.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding)
            ])
        }
        
        if showReadLabel {
            contentView.addSubview(readLabel)
            let topAnchor = message.imageUrls.isEmpty ? messageBubble.bottomAnchor : imagesStackView.bottomAnchor
            setupReadLabelConstraints(topAnchor: topAnchor)
        }
        setupMessageLabelConstraints()
        setupTimestampLabelConstraints()
    }
    
    override func prepareForReuse() {
        adminImageView.removeFromSuperview()
        imagesStackView.removeFromSuperview()
        imagesStackView.deconfigure()
        readLabel.removeFromSuperview()
        messageBubble.removeAllConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
