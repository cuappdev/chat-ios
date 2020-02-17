//
//  Feedback.swift
//  SupportClient
//
//  Created by Cameron Russell on 2/15/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

// TODO: replace this class once we hook up to database
struct Feedback: Codable {
    
    var title: String
    var message: String
    var hasRead: Bool
    
}
