//
//  TwoWayFeedback.swift
//  SupportClient
//
//  Created by Omar Rasheed on 5/9/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import Foundation

class TwoWayFeedback: Feedback {
    
    let hasRead: Bool
    let adminRep: AdminRep?
    
    enum CodingKeys: String, CodingKey {
        case hasRead
        case adminRep
    }
    
    override init(imageUrls: [String], message: String, tag: String, type: FeedbackType) {
        self.hasRead = true
        super.init(imageUrls: imageUrls, message: message, tag: tag, type: type)
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hasRead = try container.decode(Bool.self, forKey: .hasRead)
        adminRep = try? container.decode(AdminRep.self, forKey: .adminRep)
        try super.init(from: decoder)
    }
    
}
