//
//  NoResultsEmptyStateView.swift
//  SupportClient
//
//  Created by Yana Sang on 5/9/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

class NoResultsEmptyStateView: UIView {

    private let emptyStateDescriptionLabel = UILabel()
    private let emptyStateImageView = UIImageView(image: UIImage(named: "noResults", in: PatchKitImages.resourceBundle, compatibleWith: nil))
    private let emptyStateTitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    func setupViews() {
        emptyStateImageView.contentMode = .scaleAspectFit
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emptyStateImageView)

        emptyStateTitleLabel.text = "No results found"
        emptyStateTitleLabel.font = ._18RobotoRegular
        emptyStateTitleLabel.textColor = .black
        emptyStateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emptyStateTitleLabel)

        emptyStateDescriptionLabel.text = "We couldnt find any results. Try a \ndifferent search."
        emptyStateDescriptionLabel.font = ._14RobotoRegular
        emptyStateDescriptionLabel.textColor = ._darkGray
        emptyStateDescriptionLabel.textAlignment = .center
        emptyStateDescriptionLabel.numberOfLines = 0
        emptyStateDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emptyStateDescriptionLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 94),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 88),
            emptyStateImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateImageView.topAnchor.constraint(equalTo: topAnchor)
        ])

        NSLayoutConstraint.activate([
            emptyStateTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateTitleLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 38)
        ])

        NSLayoutConstraint.activate([
            emptyStateDescriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateDescriptionLabel.topAnchor.constraint(equalTo: emptyStateTitleLabel.bottomAnchor, constant: 17.5)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
