//
//  ErrorFileCollectionViewCell.swift
//  SupportClient
//
//  Created by Cameron Russell on 3/7/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import Photos
import UIKit

class ErrorFileCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "ErrorFileCollectionViewCell"
    static let imageResizingRatio: CGFloat = 1.7

    private let imageManager = PHCachingImageManager()
    private let errorFileImageView = UIImageView()
    
    private let padding: CGFloat = 20.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupContraints()
    }
    
    func setupImageView() {
        errorFileImageView.translatesAutoresizingMaskIntoConstraints = false
        errorFileImageView.contentMode = .scaleAspectFit
        errorFileImageView.layer.borderWidth = 1.0
        errorFileImageView.layer.borderColor = UIColor.black.cgColor
        errorFileImageView.layer.cornerRadius = 10.0
        // show editing screen when tapped
        errorFileImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        errorFileImageView.isUserInteractionEnabled = true
        errorFileImageView.addGestureRecognizer(tapGestureRecognizer)
        contentView.addSubview(errorFileImageView)
    }
    
    func setupContraints() {
        NSLayoutConstraint.activate([
            errorFileImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / ErrorFileCollectionViewCell.imageResizingRatio + padding / 2.0),
            errorFileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
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
                let imageWithPadding = image?.addPadding(x: self.padding, y: 2.0 * self.padding)
                self.errorFileImageView.image = imageWithPadding
                NSLayoutConstraint.activate([
                    self.errorFileImageView.heightAnchor.constraint(equalToConstant: (image?.size.height)! / ErrorFileCollectionViewCell.imageResizingRatio + self.padding / 2.0)
                ])
            }
        )
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        print(tappedImage.frame)
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ErrorFileCollectionViewCell: UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        errorFileImageView.image = image
    }
    
    
}

extension ErrorFileCollectionViewCell: UINavigationControllerDelegate {
    
}
