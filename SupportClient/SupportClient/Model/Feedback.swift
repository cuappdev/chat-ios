//
//  Feedback.swift
//  SupportClient
//
//  Created by Cameron Russell on 2/15/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

// TODO: replace this class once we hook up to database

import Foundation

struct Feedback: Codable {

    var adminName: String
    var hasRead: Bool
    let message: String
    var tags: [String]
    var time: Date
    let title: String
    let type: String
    
}
