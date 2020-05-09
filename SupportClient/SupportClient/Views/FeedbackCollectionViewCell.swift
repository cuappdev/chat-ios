//
//  FeedbackCollectionViewCell.swift
//  SupportClient
//
//  Created by Yana Sang on 5/8/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

enum FeedbackSection {
    case customerService
    case bugsAndRequests
}

class FeedbackCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "feedbackCollectionViewCell"

    private var feedbackSection: FeedbackSection = .customerService
    private var items: [Feedback] = []
    private let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BugsRequestsTableViewCell.self, forCellReuseIdentifier: BugsRequestsTableViewCell.reuseIdentifier)
        tableView.register(CustomerServiceTableViewCell.self, forCellReuseIdentifier: CustomerServiceTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tableView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(section: FeedbackSection, items: [Feedback]) {
        self.feedbackSection = section
        self.items = items
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedbackCollectionViewCell: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 103.6
    }

}

extension FeedbackCollectionViewCell: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch feedbackSection {
        case .customerService:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomerServiceTableViewCell.reuseIdentifier, for: indexPath) as! CustomerServiceTableViewCell
            cell.configure(for: items[indexPath.row])
            cell.selectionStyle = .none
            return cell
            
        case .bugsAndRequests:
            let cell = tableView.dequeueReusableCell(withIdentifier: BugsRequestsTableViewCell.reuseIdentifier, for: indexPath) as! BugsRequestsTableViewCell
            cell.configure(for: items[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
    }

}
