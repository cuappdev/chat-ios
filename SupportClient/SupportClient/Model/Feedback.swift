//
//  Feedback.swift
//  SupportClient
//
//  Created by Cameron Russell on 2/15/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//



struct Feedback: Codable {
    
    var hasRead: Bool
    var message: String
    var title: String
    var isTwoWay: Bool
    
}
