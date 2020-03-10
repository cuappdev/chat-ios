//
//  ErrorFileCollectionViewCell.swift
//  SupportClient
//
//  Created by Cameron Russell on 3/7/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit
import Photos

class ErrorFileCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "ErrorFileCollectionViewCell"
    static let imageResizingRatio: CGFloat = 1.7

    private let imageManager = PHCachingImageManager()
    private var errorFileImageView: UIImageView!
    
    private let padding: CGFloat = 20.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupContraints()
    }
    
    func setupImageView() {
        errorFileImageView = UIImageView()
        errorFileImageView.translatesAutoresizingMaskIntoConstraints = false
        errorFileImageView.contentMode = .scaleAspectFit
        errorFileImageView.layer.borderWidth = 1.0
        errorFileImageView.layer.borderColor = UIColor.black.cgColor
        errorFileImageView.layer.cornerRadius = 10.0
        contentView.addSubview(errorFileImageView)
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            errorFileImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / ErrorFileCollectionViewCell.imageResizingRatio + padding / 2.0),
            errorFileImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / ErrorFileCollectionViewCell.imageResizingRatio),
            errorFileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    // TODO: Figure out why short pause when loading images after dismissing ImagePicker
    func configure(for imageFile: PHAsset) {
        // Converts a PHAsset to a UIImage and configures the cell's image
        imageManager.requestImage(
            for: imageFile,
            targetSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),
            contentMode: .aspectFit,
            options: nil,
            resultHandler: { image, _ in
                let imageWithPadding = image?.addPadding(x: self.padding, y: 2.0 * self.padding)
                self.errorFileImageView.image = imageWithPadding
            }
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
