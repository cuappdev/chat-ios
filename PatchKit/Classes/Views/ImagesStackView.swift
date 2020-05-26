//
//  ImagesStackView.swift
//  abseil
//
//  Created by Omar Rasheed on 5/24/20.
//

import UIKit

class ImagesStackView: UIView {
    
    private let containerStackView = UIStackView()
    
    private var onImageTap: ((UIImage) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupImagesStackView()

        setupConstraints()
    }
    
    private func getImageRowStackView(interImageSpacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = interImageSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }
    
    private func getImageView(for imageUrl: String, imageSize: CGSize) -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = ._mediumGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.fetchImage(imageUrl: imageUrl)
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(sender:)))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // Doing this to fix constraint errors with auto sizing tableview
        let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: imageSize.height)
        heightConstraint.isActive = true
        heightConstraint.priority = UILayoutPriority(rawValue: 999)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: imageSize.width)
        ])
        
        return imageView
    }
    
    private func setupImagesStackView() {
        containerStackView.axis = .vertical
        containerStackView.distribution = .fillProportionally
        containerStackView.alignment = .leading
        containerStackView.spacing = 10
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerStackView)
    }
    
    func configure(for imageUrls: [String], imageSize: CGSize, interImageSpacing: CGFloat, numImagesPerRow: Int, onImageTap: ((UIImage) -> Void)? = nil) {
        containerStackView.spacing = interImageSpacing
        self.onImageTap = onImageTap
        let numRows = Int(ceil(Double(imageUrls.count) / Double(numImagesPerRow)))
        (0..<numRows).forEach { row in
            let stackView = getImageRowStackView(interImageSpacing: interImageSpacing)
            let numImagesInStackView = min(3, imageUrls.count - row * numImagesPerRow)
            (0..<numImagesInStackView).forEach { imageNum in
                let imageView = getImageView(for: imageUrls[numImagesPerRow * row + imageNum], imageSize: imageSize)
                stackView.addArrangedSubview(imageView)
            }
            containerStackView.addArrangedSubview(stackView)
        }
    }

    func unConfigure() {
        containerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    @objc private func imageTapped(sender: UITapGestureRecognizer) {
        // Go through all rows of main stackView
        containerStackView.arrangedSubviews.forEach { imageRowStackView in
            // Cast each row as UIStackView
            if let imageRowStackView = imageRowStackView as? UIStackView {
                // Go through all item of subStackView
                imageRowStackView.arrangedSubviews.forEach { imageView in
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
    
    private func setupConstraints() {
        // Doing this to fix constraint errors with auto sizing tableview
        let bottomConstraint = containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottomConstraint.isActive = true
        bottomConstraint.priority = UILayoutPriority(rawValue: 999)

        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
