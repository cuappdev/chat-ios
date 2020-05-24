//
//  CustomerServiceDetailViewController.swift
//  PatchKit
//
//  Created by Omar Rasheed on 5/24/20.
//

import UIKit

class CustomerServiceDetailViewController: UIViewController {
    
    private let bottomBar = UIView()
    private let messagesTableView = UITableView()
    
    private var messageThread: MessageThread!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupBottomBar()
        setupMessagesTableView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBottomOfNavBar()
        setupBackButton()
    }
    
    private func setupBottomBar() {
        bottomBar.backgroundColor = .blue
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBar)
    }
    
    private func setupMessagesTableView() {
        messagesTableView.dataSource = self
        messagesTableView.separatorStyle = .none
        messagesTableView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 0)
        messagesTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.reuseIdentifier)
        messagesTableView.transform = CGAffineTransform(scaleX: 1,y: -1);
        messagesTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messagesTableView)
    }
    
    func configure(for feedback: TwoWayFeedback) {
        messageThread = feedback.messageThread
        title = "\(feedback.adminRep?.name ?? feedback.type.rawValue)"
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            messagesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            messagesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messagesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        NSLayoutConstraint.activate([
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.topAnchor.constraint(equalTo: messagesTableView.bottomAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
}

extension CustomerServiceDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageThread.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.reuseIdentifier, for: indexPath) as! MessageTableViewCell
        cell.configure(for: messageThread.messages[indexPath.row], addTimeStamp: indexPath.row != messageThread.messages.count - 1)
        cell.contentView.transform = CGAffineTransform(scaleX: 1,y: -1);
        return cell
    }
    
}
