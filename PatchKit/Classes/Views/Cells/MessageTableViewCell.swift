//
//  MessageTableViewCell.swift
//  Pods
//
//  Created by Omar Rasheed on 5/24/20.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    static let reuseIdentifier = "MessageTableViewCell"
    
    private let messageBubble = UIView()
    private let messageLabel = UILabel()
    private let adminImageView = UIImageView()
    private let timeStampLabel = UILabel()
    private let imagesStackView = ImagesStackView()
    
    private let verticalPadding: CGFloat = 6

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupAdminImageView()
        setupMessageBubble()
        setupMessageLabel()
        setupTimeStampLabel()
        setupImagesStackView()
    }
    
    func setupImagesStackView() {
        imagesStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupMessageLabel() {
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageBubble.addSubview(messageLabel)
    }
    
    func setupMessageBubble() {
        messageBubble.layer.cornerRadius = 10
        messageBubble.clipsToBounds = true
        messageBubble.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageBubble)
    }
    
    func setupAdminImageView() {
        adminImageView.backgroundColor = ._mediumGray
        adminImageView.layer.cornerRadius = 12
        adminImageView.clipsToBounds = true
        adminImageView.contentMode = .scaleAspectFill
        adminImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupTimeStampLabel() {
        timeStampLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupUserMessageConstraints() {
        NSLayoutConstraint.activate([
            messageBubble.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
//            messageBubble.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding),
            messageBubble.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 80)
        ])
    }

    func setupAdminMessageConstraints() {
        NSLayoutConstraint.activate([
            adminImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            adminImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding),
            adminImageView.heightAnchor.constraint(equalToConstant: 24),
            adminImageView.widthAnchor.constraint(equalToConstant: 24)
        ])

        NSLayoutConstraint.activate([
            messageBubble.leadingAnchor.constraint(equalTo: adminImageView.trailingAnchor, constant: 8),
//            messageBubble.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding),
            messageBubble.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -80)
        ])
    }
    
    func setupMessageLabelConstraints() {
        let messagePadding: CGFloat = 12
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: messageBubble.leadingAnchor, constant: messagePadding),
            messageLabel.trailingAnchor.constraint(equalTo: messageBubble.trailingAnchor, constant: -messagePadding),
            messageLabel.topAnchor.constraint(equalTo: messageBubble.topAnchor, constant: messagePadding),
            messageLabel.bottomAnchor.constraint(equalTo: messageBubble.bottomAnchor, constant: -messagePadding)
        ])
    }
    
    func setupTimeStampLabelConstraints() {
        NSLayoutConstraint.activate([
            timeStampLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timeStampLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding)
        ])
        
        NSLayoutConstraint.activate([
            messageBubble.topAnchor.constraint(equalTo: timeStampLabel.bottomAnchor, constant: 8)
        ])
    }
    
    func setupImagesStackViewConstraints() {
        NSLayoutConstraint.activate([
            imagesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            imagesStackView.topAnchor.constraint(equalTo: messageBubble.bottomAnchor, constant: 8),
            imagesStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding)
        ])
    }

    func configure(for message: Message, addTimeStamp: Bool) {
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

        if addTimeStamp {
            timeStampLabel.attributedText = NSMutableAttributedString()
                .semibold(message.createdAt.convertToTimestamp(), size: 10)
                .normal(message.createdAt.convertToTimestamp(), size: 10)
            contentView.addSubview(timeStampLabel)
            setupTimeStampLabelConstraints()
        } else {
            NSLayoutConstraint.activate([
                messageBubble.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding)
            ])
        }
        
        if !message.imageUrls.isEmpty {
            imagesStackView.configure(for: message.imageUrls, imageSize: CGSize(width: 88, height: 88), interImageSpacing: 4)
            contentView.addSubview(imagesStackView)
            setupImagesStackViewConstraints()
        } else {
            NSLayoutConstraint.activate([
                messageBubble.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding)
            ])
        }
        setupMessageLabelConstraints()
    }
    
    override func prepareForReuse() {
        adminImageView.removeFromSuperview()
        timeStampLabel.removeFromSuperview()
        imagesStackView.removeFromSuperview()
        imagesStackView.unConfigure()
        messageBubble.removeAllConstraints()
        messageBubble.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
