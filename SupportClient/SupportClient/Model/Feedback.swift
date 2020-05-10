//
//  Feedback.swift
//  SupportClient
//
//  Created by Cameron Russell on 2/15/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import Foundation

enum FeedbackType: String, Codable {
    case bugReport = "Bug Report"
    case featureRequest = "Feature Request"
    case customerService = "Customer Service"
}

class Feedback: Codable {
    
    var createdAt: Date
    var imageUrls: [String]
    var message: String
    var tag: String
    var type: FeedbackType
    
    init(imageUrls: [String], message: String, tag: String, type: FeedbackType) {
        self.createdAt = Date()
        self.imageUrls = imageUrls
        self.message = message
        self.tag = tag
        self.type = type
    }
    
}
