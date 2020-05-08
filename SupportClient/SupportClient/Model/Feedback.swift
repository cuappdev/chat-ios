//
//  Feedback.swift
//  SupportClient
//
//  Created by Cameron Russell on 2/15/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//


enum FeedbackType: String {
    case twoway = "twoway"
    case oneway = "oneway"
}

struct Feedback: Codable {
    
    var type: String
    var has_read: Bool
    var message: String
    var title: String

    
}
