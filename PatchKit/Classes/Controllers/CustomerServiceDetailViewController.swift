//
//  CustomerServiceDetailViewController.swift
//  PatchKit
//
//  Created by Omar Rasheed on 5/24/20.
//

import UIKit

class CustomerServiceDetailViewController: UIViewController {
    
    private let addImageButton = UIButton()
    private let bottomBar = UIView()
    private let messagesTableView = UITableView()
    private let messageTextView = UITextView()
    private let sendButton = UIButton()
    
    private var messageThread: MessageThread!
    private var messageTextViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupKeyboardListeners()
        
        setupAddImageButton()
        setupBottomBar()
        setupMessagesTableView()
        setupMessageTextView()
        setupSendButton()
        setupConstraints()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboardListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBottomOfNavBar()
        setupBackButton()
    }
    
    private func setupSendButton() {
        sendButton.setImage(UIImage(named: "send", in: PatchKitImages.resourceBundle, compatibleWith: nil), for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(sendButton)
    }
    
    private func setupMessageTextView() {
        messageTextView.font = UIFont.systemFont(ofSize: 14)
        messageTextView.textContainerInset.left = 8
        messageTextView.textContainerInset.right = 8
        messageTextView.layer.cornerRadius = 16
        messageTextView.backgroundColor = ._lightGray
        messageTextView.clipsToBounds = true
        messageTextView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        messageTextView.delegate = self
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(messageTextView)
    }
    
    private func setupAddImageButton() {
        addImageButton.setImage(UIImage(named: "imagePlaceholder", in: PatchKitImages.resourceBundle, compatibleWith: nil), for: .normal)
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(addImageButton)
    }
    
    private func setupBottomBar() {
        bottomBar.backgroundColor = .white
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBar)
    }
    
    private func setupMessagesTableView() {
        messagesTableView.dataSource = self
        messagesTableView.separatorStyle = .none
        messagesTableView.allowsSelection = false
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
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
        ])
        
        NSLayoutConstraint.activate([
            addImageButton.heightAnchor.constraint(equalToConstant: 24),
            addImageButton.widthAnchor.constraint(equalToConstant: 24),
            addImageButton.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 14),
            addImageButton.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            sendButton.heightAnchor.constraint(equalToConstant: 22),
            sendButton.widthAnchor.constraint(equalToConstant: 22),
            sendButton.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -14),
            sendButton.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -16)
        ])
        
        messageTextViewHeightConstraint =             messageTextView.heightAnchor.constraint(equalToConstant: 32)
        messageTextViewHeightConstraint.isActive = true

        NSLayoutConstraint.activate([
            messageTextView.leadingAnchor.constraint(equalTo: addImageButton.trailingAnchor, constant: 16),
            messageTextView.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 12),
            messageTextView.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -12),
            messageTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -16)
        ])
    }
    
}

extension CustomerServiceDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageThread.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.reuseIdentifier, for: indexPath) as! MessageTableViewCell
        cell.configure(for: messageThread.messages[indexPath.row], showReadLabel: messageThread.hasAdminRead && indexPath.row == 0)
        cell.contentView.transform = CGAffineTransform(scaleX: 1,y: -1);
        return cell
    }
    
}

extension CustomerServiceDetailViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        messageTextViewHeightConstraint.constant = min(100, newSize.height)
    }
}
