//
//  HeaderCollectionViewCell.swift
//  SupportClient
//
//  Created by Cameron Russell on 5/7/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "HeaderCollectionViewCell"

    private let headerLabel = UILabel()
    private let underlineView = UIView()
    
    override var isSelected: Bool {
        didSet {
            headerLabel.textColor = isSelected ? .black : ._darkGray
            headerLabel.font = isSelected ? .boldSystemFont(ofSize: 14) : .systemFont(ofSize: 14)
            underlineView.isHidden = !isSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
        setupUnderline()
        setupConstraints()
    }

    func setupLabel() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.font = UIFont.systemFont(ofSize: 14)
        headerLabel.textColor = ._darkGray
        contentView.addSubview(headerLabel)
    }
    
    func setupUnderline() {
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.layer.borderWidth = 2
        underlineView.backgroundColor = .black
        underlineView.isHidden = true
        contentView.addSubview(underlineView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            headerLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        NSLayoutConstraint.activate([
            underlineView.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            underlineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            underlineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    func configure(with header: String) {
        headerLabel.text = header
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
