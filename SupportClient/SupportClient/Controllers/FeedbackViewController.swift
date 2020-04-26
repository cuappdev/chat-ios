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

protocol FeedbackViewDelegate: class {
    func selectFiles()
    func checkStatus(with status: Status)
}

class FeedbackViewController: UIViewController {
    
    private let outerScrollView = UIScrollView()
    private var feedbackView: FeedbackView!
                
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        setupNavigationBar()
        setupScrollView()
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
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func setupScrollView() {
        feedbackView =  FeedbackView(frame: UIScreen.main.bounds, with: self)
        outerScrollView.translatesAutoresizingMaskIntoConstraints = false
        outerScrollView.addSubview(feedbackView)
        outerScrollView.showsVerticalScrollIndicator = false
        view.addSubview(outerScrollView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            outerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            outerScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            outerScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            outerScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    // TODO: animation does not work after presenting ImagePicker sometimes
    @objc func handleNavigationBarLeftTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNavigationBarRightTap() {
        self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AnimateBanner"), object: nil)
        })
    }

}

// MARK: - FeedbackView Delegate
extension FeedbackViewController: FeedbackViewDelegate {
    
    func selectFiles() {
        var selectedFiles = [PHAsset]()
        let imagePicker = ImagePickerController()
        imagePicker.settings.theme.selectionStyle = .checked
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image, .video]
        self.presentImagePicker(imagePicker,
            select: nil,
            deselect: nil,
            cancel: nil,
            finish: { assets in
                selectedFiles = assets.map { $0 }
                self.feedbackView.configureFiles(for: selectedFiles)
            },
            completion: nil
        )
    }
    
    func checkStatus(with status: Status) {
        if let sendButton = self.navigationItem.rightBarButtonItem {
            sendButton.isEnabled = status == .complete
        }
    }
    
}
