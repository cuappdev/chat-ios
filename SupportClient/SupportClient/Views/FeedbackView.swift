//
//  FeedbackView.swift
//  SupportClient
//
//  Created by Cameron Russell on 4/22/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import BSImagePicker
import iOSDropDown
import Photos
import UIKit

enum Status {
    case complete
    case incomplete
}

class FeedbackView: UIView {
    
    weak var delegate: FeedbackViewDelegate?
    
    private let addFileButton = UIButton()
    private var attachedFiles = [PHAsset]()
    private var attachmentsCollectionView: UICollectionView!
    private let attachmentsLabel = UILabel()
    private let messageLabel = UILabel()
    private let messageTextView = UITextView()
    private let typeDropdown = DropDown(frame: CGRect(x: 110, y: 140, width: 200, height: 30))
    private let typeLabel = UILabel()
    
    public var status = Status.incomplete {
        didSet {
            delegate?.checkStatus(with: status)
        }
    }
    
    private let padding: CGFloat = 15
    private let imageHeight: CGFloat = 150
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAddFileButton()
        setupAttachmentsLabel()
        setupAttachmentsCollectionView()
        setupMessageLabel()
        setupMessageTextView()
        setupTypeLabel()
        setupTypeDropdown()
        setupGestureRecognizer()
        setupConstraints()
    }
    
    convenience init(frame: CGRect, with delegate: FeedbackViewDelegate) {
        self.init(frame: frame)
        self.delegate = delegate
    }
    
    func setupAddFileButton() {
        addFileButton.translatesAutoresizingMaskIntoConstraints = false
        addFileButton.layer.cornerRadius = 8
        addFileButton.layer.borderWidth = 1.0
        addFileButton.setImage(UIImage(named: "plus"), for: .normal)
        addFileButton.addTarget(self, action: #selector(addFiles(_:)), for: .touchUpInside)
        addSubview(addFileButton)
    }
    
    func setupAttachmentsLabel() {
        attachmentsLabel.translatesAutoresizingMaskIntoConstraints = false
        attachmentsLabel.text = "Attachments:"
        attachmentsLabel.font = UIFont.systemFont(ofSize: 18)
        attachmentsLabel.textColor = .black
        addSubview(attachmentsLabel)
    }
    
    func setupAttachmentsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        attachmentsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        attachmentsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        attachmentsCollectionView.delegate = self
        attachmentsCollectionView.dataSource = self
        attachmentsCollectionView.backgroundColor = .backgroundColor
        attachmentsCollectionView.showsHorizontalScrollIndicator = false
        attachmentsCollectionView.register(FileCollectionViewCell.self, forCellWithReuseIdentifier: FileCollectionViewCell.reuseID)
        addSubview(attachmentsCollectionView)
    }
    
    func setupMessageLabel() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = "Message:"
        messageLabel.font = UIFont.systemFont(ofSize: 18)
        messageLabel.textColor = .black
        addSubview(messageLabel)
    }
    
    func setupMessageTextView() {
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.text = "Let us know what happened."
        messageTextView.textColor = .lightGray
        messageTextView.delegate = self
        messageTextView.font = UIFont.systemFont(ofSize: 14)
        messageTextView.textAlignment = .left
        messageTextView.isUserInteractionEnabled = true
        messageTextView.contentInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        addSubview(messageTextView)
    }
    
    func setupTypeLabel() {
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.text = "Type:"
        typeLabel.font = UIFont.systemFont(ofSize: 18)
        typeLabel.textColor = .black
        addSubview(typeLabel)
    }
    
    func setupTypeDropdown() {
        typeDropdown.translatesAutoresizingMaskIntoConstraints = false
        typeDropdown.optionArray = ["Report Bug", "Request Feature", "Help Request", "Other"]
        typeDropdown.placeholder = "Choose a Feedback Type"
        typeDropdown.font = UIFont.systemFont(ofSize: 14)
        typeDropdown.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: typeDropdown.frame.height))
        typeDropdown.leftViewMode = .always
        typeDropdown.selectedRowColor = .gray
        typeDropdown.isSearchEnable = false
        typeDropdown.checkMarkEnabled = false
        typeDropdown.rowHeight = 40
        typeDropdown.layer.cornerRadius = 5
        typeDropdown.borderWidth = 0.5
        typeDropdown.listHeight = 200
        typeDropdown.arrowSize = 10
        addSubview(typeDropdown)
        typeDropdown.didSelect { (selectedText , index ,id) in
            self.checkStatus()
        }
    }
    
    func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            typeLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding)
        ])
        NSLayoutConstraint.activate([
            typeDropdown.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            typeDropdown.leadingAnchor.constraint(equalTo: typeLabel.trailingAnchor, constant: 2 * padding),
            typeDropdown.centerYAnchor.constraint(equalTo: typeLabel.centerYAnchor),
            typeDropdown.heightAnchor.constraint(equalToConstant: 32)
        ])
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            messageLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 2 * padding)
        ])
        NSLayoutConstraint.activate([
            messageTextView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: padding),
            messageTextView.heightAnchor.constraint(equalToConstant: 100),
            messageTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            messageTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        ])
        NSLayoutConstraint.activate([
            attachmentsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            attachmentsLabel.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: 2 * padding)
        ])
        NSLayoutConstraint.activate([
            addFileButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            addFileButton.topAnchor.constraint(equalTo: attachmentsLabel.bottomAnchor, constant: padding),
            addFileButton.widthAnchor.constraint(equalToConstant: 100),
            addFileButton.heightAnchor.constraint(equalToConstant: imageHeight)
        ])
        NSLayoutConstraint.activate([
            attachmentsCollectionView.heightAnchor.constraint(equalTo: addFileButton.heightAnchor),
            attachmentsCollectionView.leadingAnchor.constraint(equalTo: addFileButton.trailingAnchor, constant: padding),
            attachmentsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            attachmentsCollectionView.topAnchor.constraint(equalTo: addFileButton.topAnchor)
        ])
    }
    
    func checkStatus() {
        if typeDropdown.selectedIndex != nil {
            if messageTextView.textColor != UIColor.lightGray || attachedFiles.count > 0 {
                status = .complete
            } else {
                status = .incomplete
            }
        }
    }
    
    func configureFiles(for selectedFiles: [PHAsset]) {
        attachedFiles = Array(Set(self.attachedFiles + selectedFiles.map { $0 }))
        attachmentsCollectionView.reloadData()
        checkStatus()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    
    @objc func addFiles(_ sender: UIButton) {
        delegate?.selectFiles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - UICollectionView DataSource
extension FeedbackView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachedFiles.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileCollectionViewCell.reuseID, for: indexPath) as! FileCollectionViewCell
        let file = attachedFiles[indexPath.item]
        cell.configure(for: file, with: self)
        return cell
    }
    
}

// MARK: - UICollectionView Delegate
extension FeedbackView: UICollectionViewDelegate {
        
    // TODO: Open up image editor with image tapped on
    
}

// MARK: - UICollectionView DelegateFlowLayout
extension FeedbackView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let file = attachedFiles[indexPath.item]
        let width: CGFloat = CGFloat(Int(imageHeight) * file.pixelWidth / file.pixelHeight)
        return CGSize(width: width, height: imageHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
        
}

// MARK: - UITextView Delegate
extension FeedbackView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Once user begins editing, change color to text for pseudo-placeholder effect
        if textView == messageTextView, textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // If user did not add message, replace with default text
        if textView == messageTextView, textView.text.isEmpty {
            textView.text = "Let us know what happened."
            textView.textColor = .lightGray
        }
        checkStatus()
    }
    
}


// MARK: - RemoveFile Delegate
extension FeedbackView: RemoveFileDelegate {
    
    func removeFile(_ file: PHAsset) {
        attachedFiles.remove(at: attachedFiles.firstIndex(of: file)!)
        attachmentsCollectionView.reloadData()
        attachmentsCollectionView.collectionViewLayout.invalidateLayout()
        checkStatus()
    }
    
}
