//
//  UIButton+Extension.swift
//  SupportClient
//
//  Created by Cameron Russell on 4/23/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import UIKit

// Solves problem outlined here:  https://stackoverflow.com/questions/29471946/view-shows-up-in-debug-view-hierarchy-but-not-on-device-sim/46088788
class MaskedButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topRight, .bottomLeft],
            cornerRadii: CGSize(width: 8, height: 8)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }

}
