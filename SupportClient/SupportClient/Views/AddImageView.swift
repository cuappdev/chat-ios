//
//  AddImageView.swift
//  SupportClient
//
//  Created by Cameron Russell on 3/11/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

class AddImageView: CustomView {

    private let addFileButton = UIButton()
    private let noFileLabel = UILabel()
    
    @objc var onPress: (() -> Void)?

    var view: CustomView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(onPress: @escaping () -> Void) {
        self.init()
        view = CustomView(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3)
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
        view.addSubview(noFileLabel)
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
        view.addSubview(addFileButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            noFileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noFileLabel.widthAnchor.constraint(equalToConstant: 250),
            noFileLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60)
        ])
        NSLayoutConstraint.activate([
            addFileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addFileButton.topAnchor.constraint(equalTo: noFileLabel.bottomAnchor, constant: 50),
            addFileButton.widthAnchor.constraint(equalToConstant: 200),
            addFileButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc func addFileBtnPressed() {
        onPress?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
