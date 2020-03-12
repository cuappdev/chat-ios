//
//  AddImageView.swift
//  SupportClient
//
//  Created by Cameron Russell on 3/11/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

class AddImageView: UIView {

    private let addFileButton = UIButton()
    private let noFileLabel = UILabel()
    private var onPress: (() -> Void)?
    
    override var intrinsicContentSize: CGSize {
        return UIScreen.main.bounds.size
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(onPress: @escaping () -> Void) {
        super.init(frame: .zero)
        self.onPress = onPress
        setupLabel()
        setupButton()
        setupConstraints()
    }
    
    func setupLabel() {
        noFileLabel.translatesAutoresizingMaskIntoConstraints = false
        // Create ParagraphStyle to format label text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 10
        // Tell the user there are no images/videos to display
        noFileLabel.lineBreakMode = .byWordWrapping
        noFileLabel.numberOfLines = 0
        let title = "No Attached Files\n"
        let subtitle = "Add screenshots or screen recordings from your photo library if they help to describe the bug"
        let titleAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont._17RobotoMedium!,
            .paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: UIColor.titleColor
        ]
        let attributedText = NSMutableAttributedString(string: title, attributes: titleAttributes)
        let subtitleAttributes = [
            NSAttributedString.Key.font: UIFont._13RobotoRegular!,
            NSAttributedString.Key.foregroundColor: UIColor.subtitleColor,
        ]
        attributedText.append(NSAttributedString(string: subtitle, attributes: subtitleAttributes))
        noFileLabel.attributedText = attributedText
        noFileLabel.sizeToFit()
        addSubview(noFileLabel)
    }
    
    func setupButton() {
        addFileButton.translatesAutoresizingMaskIntoConstraints = false
        addFileButton.setTitle("Add Image/Video", for: .normal)
        addFileButton.setTitleColor(.gray, for: .normal)
        addFileButton.titleLabel?.font = ._17RobotoRegular
        addFileButton.layer.cornerRadius = 5
        addFileButton.layer.borderWidth = 1
        addFileButton.layer.borderColor = UIColor.gray.cgColor
        addFileButton.addTarget(self, action: #selector(addFileBtnPressed), for: .touchDragInside)
        addSubview(addFileButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            noFileLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            noFileLabel.widthAnchor.constraint(equalToConstant: 250),
            noFileLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -60)
        ])
        NSLayoutConstraint.activate([
            addFileButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addFileButton.topAnchor.constraint(equalTo: noFileLabel.bottomAnchor, constant: 50),
            addFileButton.widthAnchor.constraint(equalToConstant: 200),
            addFileButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc func addFileBtnPressed() {
        onPress?()
    }

}
