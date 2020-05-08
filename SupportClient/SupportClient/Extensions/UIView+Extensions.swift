//
//  UIView+Extensions.swift
//  SupportClient
//
//  Created by Cameron Russell on 5/7/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

extension UIView {
    
    func drawBottomBorder(height: CGFloat, color: UIColor) -> CALayer {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height + height , width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        return border
    }
    
}
