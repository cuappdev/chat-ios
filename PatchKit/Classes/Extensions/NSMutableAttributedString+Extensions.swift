//
//  NSMutableAttributedString+Extensions.swift
//  PatchKit
//
//  Created by Omar Rasheed on 5/23/20.
//

import Foundation

extension NSMutableAttributedString {

    func semibold(_ value:String, size: CGFloat) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: size, weight: .bold)
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func normal(_ value:String, size: CGFloat) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: size),
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

}
