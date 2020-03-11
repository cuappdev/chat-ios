//
//  FeedbackViewController.swift
//  SupportClient
//
//  Created by Cameron Russell on 3/6/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import BSImagePicker
import DZNEmptyDataSet
import Photos
import UIKit

class FeedbackViewController: UIViewController {

    private var attachedErrorFiles = [PHAsset]()
    private var collectionView: UICollectionView!
    
    private let messageLabel = UILabel()
    private let messageTextField = UITextField()
    private let typeLabel = UILabel()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        setupNavigationBar()
        setupCollectionView()
        setupConstraints()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .navigationTintColor
        let attributes = [
            NSAttributedString.Key.font: UIFont._21RobotoMedium!,
            NSAttributedString.Key.foregroundColor: UIColor.titleColor
        ]
        let attributedTitle = NSAttributedString(string: "New Feedback", attributes: attributes)
        title = attributedTitle.string
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(handleNavigationBarLeftTap)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Send",
            style: .plain,
            target: self,
            action: #selector(handleNavigationBarRightTap)
        )
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .backgroundColor
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ErrorFileCollectionViewCell.self, forCellWithReuseIdentifier: ErrorFileCollectionViewCell.reuseID)
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / ErrorFileCollectionViewCell.imageResizingRatio),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
        ])
    }
    
    // TODO: animation does not work after presenting ImagePicker sometimes
    @objc func handleNavigationBarLeftTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNavigationBarRightTap() {
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: - UICollectionView DataSource
extension FeedbackViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachedErrorFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ErrorFileCollectionViewCell.reuseID, for: indexPath) as! ErrorFileCollectionViewCell
        let errorFile = attachedErrorFiles[indexPath.item]
        cell.configure(for: errorFile)
        return cell
    }

}

// MARK: - UICollectionView Delegate
extension FeedbackViewController: UICollectionViewDelegate {
    
    // TODO: Respond to user taps to open image editor for markup
    
}

// MARK: - UICollectionView DelegateFlowLayout
extension FeedbackViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let scaledScreenWidth = view.layer.bounds.width / ErrorFileCollectionViewCell.imageResizingRatio
        let scaledScreenHeight = view.layer.bounds.height / ErrorFileCollectionViewCell.imageResizingRatio
        return CGSize(width: scaledScreenWidth, height: scaledScreenHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let collectionViewImagePadding = (UIScreen.main.bounds.width - UIScreen.main.bounds.width / ErrorFileCollectionViewCell.imageResizingRatio) / 2.0
        return UIEdgeInsets(top: 0, left: collectionViewImagePadding, bottom: 0, right: collectionViewImagePadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }

}

// MARK: - DZNEmptyDataSet
extension FeedbackViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    // If no screenshots/videos are added by the user, they are prompted to add files
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        
        let customView = CustomView(width: view.layer.bounds.width, height: view.layer.bounds.height / 3)
        customView.backgroundColor = UIColor.backgroundColor
        
        let noFileLabel = UILabel()
        noFileLabel.translatesAutoresizingMaskIntoConstraints = false
        // Create ParagraphStyle to format label text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 10
        // Tell the user there are no images/videos to display
        noFileLabel.lineBreakMode = .byWordWrapping
        noFileLabel.numberOfLines = 0
        let title = "No Attached Files\n"
        let subtitle = "Add screenshots or screen recordings from your photo library if they help to describe the bug"
        let titleAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont._17RobotoMedium!,
            .paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: UIColor.titleColor
        ]
        let attributedText = NSMutableAttributedString(string: title, attributes: titleAttributes)
        let subtitleAttributes = [
            NSAttributedString.Key.font: UIFont._13RobotoRegular!,
            NSAttributedString.Key.foregroundColor: UIColor.subtitleColor,
        ]
        attributedText.append(NSAttributedString(string: subtitle, attributes: subtitleAttributes))
        noFileLabel.attributedText = attributedText
        noFileLabel.sizeToFit()
        
        let addFileButton = UIButton()
        addFileButton.translatesAutoresizingMaskIntoConstraints = false
        addFileButton.setTitle("Add Image/Video", for: .normal)
        addFileButton.setTitleColor(.gray, for: .normal)
        addFileButton.titleLabel?.font = ._17RobotoRegular
        addFileButton.layer.cornerRadius = 5
        addFileButton.layer.borderWidth = 1
        addFileButton.layer.borderColor = UIColor.gray.cgColor
        addFileButton.addTarget(self, action: #selector(handleAddFileButtonTap), for: .touchDragInside)
        
        customView.addSubview(noFileLabel)
        customView.addSubview(addFileButton)
        
        NSLayoutConstraint.activate([
            noFileLabel.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            noFileLabel.widthAnchor.constraint(equalToConstant: 250),
            noFileLabel.centerYAnchor.constraint(equalTo: customView.centerYAnchor, constant: -60)
        ])
        
        NSLayoutConstraint.activate([
            addFileButton.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            addFileButton.topAnchor.constraint(equalTo: noFileLabel.bottomAnchor, constant: 50),
            addFileButton.widthAnchor.constraint(equalToConstant: 200),
            addFileButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        return customView
        
    }
    
    @objc func handleAddFileButtonTap() {
        // ImagePicker reinitialized to handle previous modal view lifecycle error
        let imagePicker = ImagePickerController()
        imagePicker.settings.theme.selectionStyle = .checked
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image, .video]
        presentImagePicker(imagePicker,
            select: nil,
            deselect: nil,
            cancel: nil,
            finish: { assets in
                self.attachedErrorFiles = assets.map { $0 }
                self.collectionView.reloadData()
            },
            completion: nil
        )
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
}
