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
    
    var title: UILabel!
    var subtitle: UILabel!
    var unreadImageView: UIImageView!
    
    let padding: Int = 24

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
        
        unreadImageView = UIImageView(image: UIImage(named: "unreadDot"))
        unreadImageView.contentMode = .scaleAspectFit
        unreadImageView.isHidden = true
        contentView.addSubview(unreadImageView)
        
    }
    
    func setUpTitle() {
        
        title = UILabel()
        title.font = UIFont(name: Constants.robotoMedium, size: 17)
        title.textColor = Constants.titleColor
        title.numberOfLines = 1
        title.lineBreakMode = .byTruncatingTail
        contentView.addSubview(title)
        
    }
    
    func setUpSubtitle() {
        
        subtitle = UILabel()
        subtitle.font = UIFont(name: Constants.robotoMedium, size: 13)
        subtitle.textColor = Constants.subtitleColor
        subtitle.numberOfLines = 1
        subtitle.lineBreakMode = .byTruncatingTail
        contentView.addSubview(subtitle)
        
    }
    
    func setUpConstraints() {
        
        title.snp.makeConstraints { (make) in
            make.leading.equalTo(padding)
            make.width.equalTo(Int(UIScreen.main.bounds.width) - 3 * padding)
            make.top.equalTo(20)
        }
        
        subtitle.snp.makeConstraints { (make) in
            make.leading.equalTo(padding)
            make.width.equalTo(Int(UIScreen.main.bounds.width) - 3 * padding)
            make.top.equalTo(title.snp.bottom).inset(-5)
        }
        
        unreadImageView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(padding)
            make.centerY.equalToSuperview()
        }
        
    }
    
    func configure(feedback: Feedback) {
        title.text = feedback.title
        subtitle.text = feedback.message
        unreadImageView.isHidden = !feedback.hasUnread
    }
    
    // TODO: remove this once hooked up to database
    func toggleRead(for feedback: Feedback) {
        unreadImageView.isHidden = !feedback.hasUnread
    }
    
}

