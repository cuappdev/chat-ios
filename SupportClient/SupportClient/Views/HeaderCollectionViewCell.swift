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
    
    override var isSelected: Bool {
        didSet {
            headerLabel.textColor = isSelected ? .black : ._darkGray
            headerLabel.font = isSelected ? .boldSystemFont(ofSize: 14) : .systemFont(ofSize: 14)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
        setupConstraints()
    }

    func setupLabel() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.font = UIFont.systemFont(ofSize: 14)
        headerLabel.textColor = ._darkGray
        contentView.addSubview(headerLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            headerLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with header: String) {
        headerLabel.text = header
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
