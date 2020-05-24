//
//  Message.swift
//  Pods
//
//  Created by Omar Rasheed on 5/24/20.
//

import Foundation

struct Message: Codable {

    let content: String
    let createdAt: Date
    let imageUrls: [String]
    let isFromAdmin: Bool
    
    init(content: String, imageUrls: [String] = [], isFromAdmin: Bool) {
        self.createdAt = Date()
        self.content = content
        self.imageUrls = imageUrls
        self.isFromAdmin = isFromAdmin
    }
    
}
