//
//  Feedback.swift
//  SupportClient
//
//  Created by Cameron Russell on 2/15/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import Foundation

// TODO: replace this class once we hook up to database
class Feedback {
    
    var title: String!
    var message: String!
    var hasUnread: Bool!
    
    init(title: String, message: String, hasUnread: Bool) {
        
        self.title = title
        self.message = message
        self.hasUnread = hasUnread
        
    }
    
}
