//
//  FeedbackViewController.swift
//  SupportClient
//
//  Created by Cameron Russell on 3/6/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit
import SnapKit
import DZNEmptyDataSet
import BSImagePicker
import Photos

class FeedbackViewController: UIViewController {

    // Invariant: attachedErrorFiles should only contain UIImage or AVPlayer
    private var attachedErrorFiles = [Any]()
    private var collectionView: UICollectionView!
    
    private let messageLabel = UILabel()
    private let messageTextField = UITextField()
    private let typeLabel = UILabel()
        
    private let collectionViewHeight = UIScreen.main.bounds.height / 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor
        setupNavigationBar()
        setupImagePicker()
        setupCollectionView()
        setupConstraints()
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationTintColor
        let attributes = [
            NSAttributedString.Key.font: UIFont._21RobotoMedium!,
            NSAttributedString.Key.foregroundColor: UIColor.titleColor
        ]
        let attributedTitle = NSAttributedString(string: "New Feedback", attributes: attributes)
        title = attributedTitle.string
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(handleNavigationBarLeftTap)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Send",
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(handleNavigationBarRightTap)
        )
    }
    
    func setupImagePicker() {
        
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ErrorFileCollectionViewCell.self, forCellWithReuseIdentifier: ErrorFileCollectionViewCell.reuseID)
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(collectionViewHeight / 4)
            make.height.equalTo(collectionViewHeight)
        }
    }
    
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
        let errorFile = attachedErrorFiles[indexPath.item] as! UIImage
        cell.configure(for: errorFile)
        return cell
    }

}

// MARK: - UICollectionView Delegate
extension FeedbackViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionView DelegateFlowLayout
extension FeedbackViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let scaledScreenWidth = view.layer.bounds.width / 3
        let scaledScreenHeight = view.layer.bounds.height / 3
        return CGSize(width: scaledScreenWidth, height: scaledScreenHeight)
    }

}

// MARK: - DZNEmptyDataSet
extension FeedbackViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    private static let noFileLabel = UILabel()
    private static let addFileButton = UIButton()
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        let customView = CustomUIView(width: view.layer.bounds.width, height: collectionViewHeight)
        customView.backgroundColor = UIColor.backgroundColor
        setupEmptyDataSetLabel()
        setupEmptyDataSetButton()
        customView.addSubview(FeedbackViewController.noFileLabel)
        customView.addSubview(FeedbackViewController.addFileButton)
        setupEmptyDataSetConstraints()
        return customView
    }
    
    func setupEmptyDataSetLabel() {
        // Create ParagraphStyle to format label text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 10
        // Tell the user there are no images/videos to display
        FeedbackViewController.noFileLabel.lineBreakMode = .byWordWrapping
        FeedbackViewController.noFileLabel.numberOfLines = 0
        let title = "No Attached Files Yet\n"
        let subtitle = "Add screenshots or screen recordings from your library"
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
        FeedbackViewController.noFileLabel.attributedText = attributedText
        FeedbackViewController.noFileLabel.sizeToFit()
    }
    
    func setupEmptyDataSetButton() {
        FeedbackViewController.addFileButton.setTitle("Add Image/Video", for: .normal)
        FeedbackViewController.addFileButton.setTitleColor(.gray, for: .normal)
        FeedbackViewController.addFileButton.titleLabel?.font = UIFont._17RobotoRegular
        FeedbackViewController.addFileButton.layer.cornerRadius = 5
        FeedbackViewController.addFileButton.layer.borderWidth = 1
        FeedbackViewController.addFileButton.layer.borderColor = UIColor.gray.cgColor
        FeedbackViewController.addFileButton.addTarget(self, action: #selector(handleAddFileButtonTap), for: .touchDragInside)
    }
    
    func setupEmptyDataSetConstraints() {
        FeedbackViewController.noFileLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.60)
            make.centerY.equalToSuperview().offset(-60)
        }
        FeedbackViewController.addFileButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(FeedbackViewController.noFileLabel.snp.bottom).offset(50)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(45)
        }
    }
    
    // TODO: change to intended functionality
    @objc func handleAddFileButtonTap() {
        let imagePicker = ImagePickerController()
        imagePicker.settings.theme.selectionStyle = .checked
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image, .video]
        presentImagePicker(imagePicker, select: { (asset) in
            print("Selected: \(asset)")
        }, deselect: { (asset) in
            print("Deselected: \(asset)")
        }, cancel: { (assets) in
            print("Canceled with selections: \(assets)")
        }, finish: { (assets) in
            print("Finished with selections: \(assets)")
        }, completion: nil
        )
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
}
