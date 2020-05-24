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
    
    private let verticalPadding: CGFloat = 6

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupMessageBubble()
        setupConstraints()
    }
    
    func setupMessageBubble() {
        messageBubble.backgroundColor = ._messageBlue
        messageBubble.layer.cornerRadius = 10
        messageBubble.clipsToBounds = true
        messageBubble.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageBubble)
    }


    func setupConstraints() {
        NSLayoutConstraint.activate([
            messageBubble.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            messageBubble.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalPadding),
            messageBubble.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalPadding),
            messageBubble.widthAnchor.constraint(equalToConstant: 70),
            messageBubble.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    func configure(for message: Message) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
