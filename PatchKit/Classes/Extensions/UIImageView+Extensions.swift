//
//  UIImageView+Extensions.swift
//  abseil
//
//  Created by Omar Rasheed on 5/24/20.
//

import Foundation

extension UIImageView {
    
    func fetchImage(imageUrl: String) {
        Network.shared.getImage(imageURL: imageUrl) { image in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
}
