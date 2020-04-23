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
<<<<<<< HEAD
    
    private let outerScrollView = UIScrollView()
=======

    private var attachedErrorFiles = [PHAsset]()
    private var collectionView: UICollectionView!
    
    private let messageLabel = UILabel()
    private let messageTextField = UITextField()
    private let typeLabel = UILabel()
>>>>>>> b7a2f3d55738e81d06de53566acff931fde8e9b4
                
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        setupNavigationBar()
<<<<<<< HEAD
        setupScrollView()
=======
        setupCollectionView()
>>>>>>> b7a2f3d55738e81d06de53566acff931fde8e9b4
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
<<<<<<< HEAD
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func setupScrollView() {
        outerScrollView.translatesAutoresizingMaskIntoConstraints = false
        outerScrollView.addSubview(FeedbackView(frame: view.bounds))
        outerScrollView.showsVerticalScrollIndicator = false
        view.addSubview(outerScrollView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            outerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            outerScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            outerScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            outerScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
=======
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
>>>>>>> b7a2f3d55738e81d06de53566acff931fde8e9b4
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
<<<<<<< HEAD
=======

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
        return
            AddImageView(
                onPress: {
                    let imagePicker = ImagePickerController()
                    imagePicker.settings.theme.selectionStyle = .checked
                    imagePicker.settings.fetch.assets.supportedMediaTypes = [.image, .video]
                    self.presentImagePicker(imagePicker,
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
            )
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
}
>>>>>>> b7a2f3d55738e81d06de53566acff931fde8e9b4
