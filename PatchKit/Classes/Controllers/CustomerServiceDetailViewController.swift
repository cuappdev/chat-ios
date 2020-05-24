//
//  CustomerServiceDetailViewController.swift
//  PatchKit
//
//  Created by Omar Rasheed on 5/24/20.
//

import UIKit

class CustomerServiceDetailViewController: UIViewController {
    
    let messagesTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBottomOfNavBar()
        setupBackButton()
    }

    func configure(for feedback: TwoWayFeedback) {
        title = "\(feedback.adminRep?.name ?? feedback.type.rawValue)"
    }

    private func setupConstraints() {
        
    }

}

