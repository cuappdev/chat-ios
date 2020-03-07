//
//  ErrorFileCollectionViewCell.swift
//  SupportClient
//
//  Created by Cameron Russell on 3/7/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit
import SnapKit

class ErrorFileCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "ErrorFileCollectionViewCell"
    
    var errorFileImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        errorFileImageView = UIImageView()
        errorFileImageView.contentMode = .scaleAspectFit
        contentView.addSubview(errorFileImageView)
        setupContraints()
    }
    
    func setupContraints() {
        errorFileImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.top.equalTo(contentView.snp.top).inset(50)
            make.bottom.equalTo(contentView.snp.bottom).inset(-50)
        }
    }
    
    func configure(for imageFile: UIImage) {
        errorFileImageView.image = imageFile
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
