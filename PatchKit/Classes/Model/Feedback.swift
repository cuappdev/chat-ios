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

class Feedback: Codable {

    let createdAt: Date
    let type: FeedbackType

    func isTwoWay() -> Bool {
        return type == .customerService
    }

    init(type: FeedbackType) {
        self.createdAt = Date()
        self.type = type
    }

}
