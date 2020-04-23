//
//  ErrorFileCollectionViewCell.swift
//  SupportClient
//
//  Created by Cameron Russell on 3/7/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import Photos
import UIKit

class FileCollectionViewCell: UICollectionViewCell, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    static let reuseID = "ErrorFileCollectionViewCell"

    private let imageManager = PHCachingImageManager()
    private let fileImageView = UIImageView()
    private let removeFileButton = MaskedButton()
    
    private let padding: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupRemoveFileButton()
        setupContraints()
    }
    
    func setupImageView() {
        fileImageView.translatesAutoresizingMaskIntoConstraints = false
        fileImageView.contentMode = .scaleAspectFit
        fileImageView.layer.borderWidth = 1.0
        fileImageView.layer.borderColor = UIColor.black.cgColor
        fileImageView.layer.cornerRadius = 8
        fileImageView.layer.masksToBounds = true
        fileImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        fileImageView.isUserInteractionEnabled = true
        fileImageView.addGestureRecognizer(tapGestureRecognizer)
        contentView.addSubview(fileImageView)
    }
    
    func setupRemoveFileButton() {
        removeFileButton.translatesAutoresizingMaskIntoConstraints = false
        removeFileButton.setTitle("✕", for: .normal)
        removeFileButton.backgroundColor = .red
        removeFileButton.contentHorizontalAlignment = .center
        removeFileButton.contentVerticalAlignment = .center
        contentView.addSubview(removeFileButton)
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            fileImageView.heightAnchor.constraint(equalToConstant: 150),
            fileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        NSLayoutConstraint.activate([
            removeFileButton.widthAnchor.constraint(equalToConstant: 20),
            removeFileButton.heightAnchor.constraint(equalToConstant: 20),
            removeFileButton.trailingAnchor.constraint(equalTo: fileImageView.trailingAnchor),
            removeFileButton.topAnchor.constraint(equalTo: fileImageView.topAnchor)
        ])
    }
    
    // TODO: Figure out why short pause when loading images after dismissing ImagePicker
    func configure(for imageFile: PHAsset) {
        // Converts a PHAsset to a UIImage and configures the cell's image
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        imageManager.requestImage(
            for: imageFile,
            targetSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),
            contentMode: .aspectFit,
            options: options,
            resultHandler: { image, _ in
                self.fileImageView.image = image
                let width = 150 * (image?.size.width)! / (image?.size.height)!
                NSLayoutConstraint.activate([
                    self.fileImageView.widthAnchor.constraint(equalToConstant: width)
                ])
            }
        )
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


