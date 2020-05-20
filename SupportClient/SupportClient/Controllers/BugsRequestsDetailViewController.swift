//
//  BugsRequestsDetailViewController.swift
//  SupportClient
//
//  Created by Omar Rasheed on 5/13/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

class BugsRequestsDetailViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let messageLabel = UILabel()
    private let timeLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Bug Report ° UX/UI"
        view.backgroundColor = .white
        
        setupScrollView()
        setupMessageTextView()
        setupTimesLabel()
        
        setupConstraints()
    }
    
    func setupScrollView() {
        scrollView.contentInset = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
    }
    
    func setupMessageTextView() {
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(messageLabel)
    }
    
    func setupTimesLabel() {
        timeLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        timeLabel.textColor = ._textGray
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(timeLabel)
    }
    
    func configure(for feedback: Feedback) {
        // TODO: Bold first part of time label text
        timeLabel.text = feedback.createdAt.convertToTimestamp()
        messageLabel.text = feedback.message
    }
    
    func setupConstraints() {        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: view.frame.width),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor),
            timeLabel.trailingAnchor.constraint(lessThanOrEqualTo: scrollView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            messageLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: scrollView.trailingAnchor)
        ])
    }
}
