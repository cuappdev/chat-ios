//
//  OneWayFeedbackDetailViewController.swift
//  SupportClient
//
//  Created by Omar Rasheed on 5/13/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

class OneWayFeedbackDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Bug Report ° UX/UI"

        // Do any additional setup after loading the view.
    }
    
    init(feedback: Feedback) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
