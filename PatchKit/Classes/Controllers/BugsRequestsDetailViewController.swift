//
//  BugsRequestsDetailViewController.swift
//  SupportClient
//
//  Created by Omar Rasheed on 5/13/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

class BugsRequestsDetailViewController: UIViewController {
    
    private var imagesStackView = ImagesStackView()
    private let messageLabel = UILabel()
    private let scrollView = UIScrollView()
    private let timeLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        setupImagesStackView()
        setupScrollView()
        setupMessageTextView()
        setupTimesLabel()
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBottomOfNavBar()
        setupBackButton()
    }
    
    private func setupImagesStackView() {
        imagesStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imagesStackView)
    }
    
    private func setupScrollView() {
        scrollView.contentInset = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
        scrollView.contentSize.width = UIScreen.main.bounds.width
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
    }
    
    private func setupMessageTextView() {
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(messageLabel)
    }
    
    private func setupTimesLabel() {
        timeLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        timeLabel.textColor = ._textGray
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(timeLabel)
    }
    
    func configure(for feedback: OneWayFeedback) {
        let createdAtString = feedback.createdAt.formatDateString(format: "MMM d | h:mm a")
        if let dividerIndex = createdAtString.firstIndex(of: "|") {
            let createdAtFontSize: CGFloat = 10
            let boldedText = String(createdAtString.prefix(upTo: dividerIndex))
            let unBoldedText = String(createdAtString.suffix(from: dividerIndex))
            timeLabel.attributedText = NSMutableAttributedString()
                .semibold(boldedText, size: createdAtFontSize)
                .normal(unBoldedText, size: createdAtFontSize)
        }
        title = "\(feedback.type.rawValue)\(!feedback.tags.isEmpty ? "  •  \(feedback.tags[0])" : "")"
        messageLabel.text = feedback.message
        imagesStackView.configure(
            for: feedback.imageUrls,
            imageSize: CGSize(width: 102, height: 192),
            onImageTap: { image in
                let vc = ImageDetailViewController()
                vc.configure(for: image)
                self.present(vc, animated: true, completion: nil)
        })
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            timeLabel.trailingAnchor.constraint(lessThanOrEqualTo: scrollView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            messageLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 12),
            messageLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant:-(scrollView.contentInset.left + scrollView.contentInset.right))
        ])
        
        NSLayoutConstraint.activate([
            imagesStackView.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            imagesStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            imagesStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imagesStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant:-(scrollView.contentInset.left + scrollView.contentInset.right)),
            imagesStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

}

