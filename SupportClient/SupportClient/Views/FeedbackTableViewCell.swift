//
//  FeedbackViewCell.swift
//  SupportClient
//
//  Created by Cameron Russell on 2/15/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit
import SnapKit

class FeedbackTableViewCell: UITableViewCell {
    
    static let reuseID: String = "FeedbackTableViewCell"
    
    private let subtitleLabel = UILabel()
    private let titleLabel = UILabel()
    private let unreadImageView = UIImageView()
    
    private let padding: Int = 24

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
        unreadImageView.image = UIImage(named: "unreadDot")
        unreadImageView.contentMode = .scaleAspectFit
        unreadImageView.isHidden = true
        contentView.addSubview(unreadImageView)
    }
    
    func setUpTitle() {
        titleLabel.font = UIFont._17RobotoMedium
        titleLabel.textColor = UIColor.titleColor
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(titleLabel)
    }
    
    func setUpSubtitle() {
        subtitleLabel.font = UIFont._13RobotoMedium
        subtitleLabel.textColor = UIColor.subtitleColor
        subtitleLabel.numberOfLines = 1
        subtitleLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(subtitleLabel)
    }
    
    func setUpConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(padding)
            make.width.equalToSuperview().inset(padding * 2)
            make.top.equalTo(20)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(padding)
            make.width.equalToSuperview().inset(padding * 2)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        unreadImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(padding)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(feedback: Feedback) {
        titleLabel.text = feedback.title
        subtitleLabel.text = feedback.message
        unreadImageView.isHidden = feedback.hasRead
    }
    
}
