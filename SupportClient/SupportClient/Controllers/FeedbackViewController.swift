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
    
    private let outerScrollView = UIScrollView()
                
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
