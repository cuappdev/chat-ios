//
//  UIView+Extensions.swift
//  PatchKit
//
//  Created by Omar Rasheed on 5/24/20.
//

import Foundation

extension UIView {
    
    public func removeAllConstraints() {
        var _superview = self.superview
        
        while let superview = _superview {
            for constraint in superview.constraints {
                
                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }
                
                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }
            
            _superview = superview.superview
        }
        removeConstraints(constraints)
    }
    
}
