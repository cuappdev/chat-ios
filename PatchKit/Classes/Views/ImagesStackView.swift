//
//  ImagesStackView.swift
//  abseil
//
//  Created by Omar Rasheed on 5/24/20.
//

import UIKit

class ImagesStackView: UIView {
    
    private var imagesStackView = UIStackView()
    
    private var onImageTap: ((UIImage) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupImagesStackView()

        setupConstraints()
    }
    
    func getImageRowStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10.5
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }
    
    func getImageView(for imageUrl: String, imageSize: CGSize) -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = ._mediumGray
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.fetchImage(imageUrl: imageUrl)
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: imageSize.height),
            imageView.widthAnchor.constraint(equalToConstant: imageSize.width)
        ])
        
        return imageView
    }
    
    func setupImagesStackView() {
        imagesStackView.axis = .vertical
        imagesStackView.distribution = .fillProportionally
        imagesStackView.alignment = .leading
        imagesStackView.spacing = 10
        imagesStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imagesStackView)
    }
    
    func configure(for imageUrls: [String], imageSize: CGSize, onImageTap: ((UIImage) -> Void)? = nil) {
        self.onImageTap = onImageTap
        let numRows = Int(ceil(Double(imageUrls.count) / 3))
        let numImagesPerRow = 3
        (0..<numRows).forEach { row in
            let stackView = getImageRowStackView()
            let numImagesInStackView = min(3, imageUrls.count - row * numImagesPerRow)
            (0..<numImagesInStackView).forEach { imageNum in
                let imageView = getImageView(for: imageUrls[numImagesPerRow * row + imageNum], imageSize: imageSize)
                stackView.addArrangedSubview(imageView)
            }
            imagesStackView.addArrangedSubview(stackView)
        }
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        // Go through all rows of main stackView
        imagesStackView.arrangedSubviews.forEach { containerStackView in
            // Cast each row as UIStackView
            if let containerStackView = containerStackView as? UIStackView {
                // Go through all item of subStackView
                containerStackView.arrangedSubviews.forEach { imageView in
                    // Cast each column as UIImageView, check if is sender, and pull image if not nil
                    if let imageView = imageView as? UIImageView,
                        imageView == sender.view,
                        let image = imageView.image {
                        onImageTap?(image)
                    }
                }
            }
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imagesStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imagesStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imagesStackView.topAnchor.constraint(equalTo: topAnchor),
            imagesStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}