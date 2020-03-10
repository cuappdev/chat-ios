//
//  UIImage+Extensions.swift
//  SupportClient
//
//  Created by Cameron Russell on 3/9/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

extension UIImage {

    func addPadding(x: CGFloat, y: CGFloat) -> UIImage? {
        let width = size.width + x
        let height = size.height + y
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        let origin = CGPoint(x: x/2, y: y/2)
        draw(at: origin)
        let imageWithPadding = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithPadding
    }
    
}
