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
    case customerService = "Customer Service"
    case featureRequest = "Feature Request"
}

struct Feedback: Codable {
    
    let adminRep: AdminRep?
    let createdAt: Date
    let hasRead: Bool?
    let imageUrls: [String]
    let message: String
    let tags: [String]
    let type: FeedbackType
    
    func isTwoWay() -> Bool {
        return type == .customerService
    }
    
    init(imageUrls: [String], message: String, tags: [String], type: FeedbackType) {
        self.createdAt = Date()
        self.imageUrls = imageUrls
        self.message = message
        self.tags = tags
        self.type = type
        self.hasRead = self.type == .customerService ? false : nil
        self.adminRep = nil
    }
    
}


