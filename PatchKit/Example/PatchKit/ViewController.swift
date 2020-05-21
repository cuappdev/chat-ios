//
//  ViewController.swift
//  PatchKit
//
//  Created by omarrasheed on 05/21/2020.
//  Copyright (c) 2020 omarrasheed. All rights reserved.
//

import UIKit
import PatchKit

class ViewController: UIViewController {
    
    let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        button.setTitle("Press for portal", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(presentPortal), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func presentPortal() {
        navigationController?.pushViewController(TestViewController(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

