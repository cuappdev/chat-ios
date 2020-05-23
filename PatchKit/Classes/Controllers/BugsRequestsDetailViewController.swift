//
//  BugsRequestsDetailViewController.swift
//  SupportClient
//
//  Created by Omar Rasheed on 5/13/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

class BugsRequestsDetailViewController: UIViewController {
    
    private var imagesCollectionView: UICollectionView!
    private let messageLabel = UILabel()
    private let scrollView = UIScrollView()
    private let timeLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Bug Report ° UX/UI"
        view.backgroundColor = .white
        
        addBottomOfNavBar()
        
        setupImagesCollectonView()
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
    
    func setupImagesCollectonView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        imagesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        imagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imagesCollectionView.backgroundColor = .white
        imagesCollectionView.isScrollEnabled = false
        imagesCollectionView.dataSource = self
//        imagesCollectionView.delegate = self
        imagesCollectionView.register(FeedbackImageCollectionViewCell.self, forCellWithReuseIdentifier: FeedbackImageCollectionViewCell.reuseID)
        scrollView.addSubview(imagesCollectionView)
    }
    
    func setupScrollView() {
        scrollView.contentInset = UIEdgeInsets(top: 20, left: 24, bottom: 20, right: 24)
        scrollView.contentSize.width = UIScreen.main.bounds.width
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
        let createdAtString = feedback.createdAt.formatDateString(format: "MMM d | h:mm a")
        if let dividerIndex = createdAtString.firstIndex(of: "|") {
            let createdAtFontSize: CGFloat = 10
            let boldedText = String(createdAtString.prefix(upTo: dividerIndex))
            let unBoldedText = String(createdAtString.suffix(from: dividerIndex))
            timeLabel.attributedText = NSMutableAttributedString()
                .semibold(boldedText, size: createdAtFontSize)
                .normal(unBoldedText, size: createdAtFontSize)
        }
        messageLabel.text = feedback.message
    }
    
    func setupConstraints() {        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 20),
            timeLabel.trailingAnchor.constraint(lessThanOrEqualTo: scrollView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            messageLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: scrollView.trailingAnchor),
            messageLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 48)
        ])
        
        NSLayoutConstraint.activate([
            imagesCollectionView.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            imagesCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imagesCollectionView.heightAnchor.constraint(equalToConstant:500),
            imagesCollectionView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20)
        ])
    }
}

// MARK: - UICollectionView DataSource
extension BugsRequestsDetailViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedbackImageCollectionViewCell.reuseID, for: indexPath) as! FeedbackImageCollectionViewCell
        cell.configure(with: "", onImageLoad: {
            collectionView.reloadData()
        })
        return cell
    }
    
}

//// MARK: - UICollectionView DelegateFlowLayout
//extension BugsRequestsDetailViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 100, height: 100)
//    }
//
//}
