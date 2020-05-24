//
//  ImageDetailViewController.swift
//  abseil
//
//  Created by Omar Rasheed on 5/24/20.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    private let dismissButton = UIButton()
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupImageView()
        setupDismissButton()
        
        setupConstraints()
    }
    
    private func setupDismissButton() {
        dismissButton.backgroundColor = .white
        dismissButton.layer.cornerRadius = 20
        dismissButton.setImage(UIImage(named: "back", in: PatchKitImages.resourceBundle, compatibleWith: nil), for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        dismissButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(dismissButton)
    }
    
    func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
    }
    
    func configure(for image: UIImage) {
        imageView.image = image
    }
    
    @objc private func dismissButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            dismissButton.heightAnchor.constraint(equalToConstant: 20 + dismissButton.contentEdgeInsets.top + dismissButton.contentEdgeInsets.bottom),
            dismissButton.widthAnchor.constraint(equalToConstant: 20 + dismissButton.contentEdgeInsets.left + dismissButton.contentEdgeInsets.right)
        ])
    }

}
