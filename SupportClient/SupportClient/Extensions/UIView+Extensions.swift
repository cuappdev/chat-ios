//
//  UIView+Extensions.swift
//  SupportClient
//
//  Created by Cameron Russell on 3/6/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

// Resolves DZNEmptyDataSet issue #263
class CustomUIView: UIView {
    
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    
    convenience init(width: CGFloat, height: CGFloat) {
        self.init()
        self.width = width
        self.height = height
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: width, height: height)
        }
    }
    
}
