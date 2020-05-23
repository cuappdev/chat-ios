//
//  FeedbackImageCollectionViewCell.swift
//  abseil
//
//  Created by Omar Rasheed on 5/23/20.
//

import UIKit

class FeedbackImageCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "FeedbackImageCollectionViewCell"

    private let imageView = UIImageView()
    private var image: UIImage?
    private var isHeightCalculated: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupConstraints()
    }
    
    func setupImageView() {
        imageView.backgroundColor = .gray
        contentView.addSubview(imageView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: CGFloat(Int.random(in: 100..<200))),
            imageView.widthAnchor.constraint(equalToConstant: CGFloat(Int.random(in: 100..<200)))
        ])
    }
    
    func configure(with imageUrl: String, onImageLoad: @escaping () -> Void) {
        image = nil
        imageView.image = nil
//        Network.shared.getImage(imageURL: imageUrl) { image in
//            self.imageView.image = image
//            onImageLoad()
//        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        //Exhibit A - We need to cache our calculation to prevent a crash.
        if !isHeightCalculated {
            setNeedsLayout()
            layoutIfNeeded()
            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
            var newFrame = layoutAttributes.frame
            newFrame.size.width = CGFloat(ceilf(Float(size.width)))
            layoutAttributes.frame = newFrame
            isHeightCalculated = true
        }
        return layoutAttributes
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
