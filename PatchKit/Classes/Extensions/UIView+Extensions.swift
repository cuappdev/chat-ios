//
//  UIView+Extensions.swift
//  PatchKit
//
//  Created by Omar Rasheed on 5/24/20.
//

import Foundation

extension UIView {
    
    /*
     After calling removeConstraints(constraints) it's done executing, your view remains
     where it was because it creates autoresizing constraints. When I don't do this the
     view usually disappears. Additionally, it doesn't just remove constraints from
     superview but traverses all the way up as there may be constraints affecting it in
     ancestor views.
     More info: https://stackoverflow.com/questions/24418884/remove-all-constraints-affecting-a-uiview/30491911#30491911
     */
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
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
