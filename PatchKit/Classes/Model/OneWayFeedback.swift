//
//  OneWayFeedback.swift
//  SupportClient
//
//  Created by Omar Rasheed on 5/20/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import Foundation

class OneWayFeedback: Feedback {
    
    let imageUrls: [String]
    let message: String
    let tags: [String]
    
    enum CodingKeys: String, CodingKey {
        case imageUrls
        case message
        case tags
    }

    init(imageUrls: [String], message: String, tags: [String], type: FeedbackType) {
        self.imageUrls = imageUrls
        self.message = message
        self.tags = tags
        super.init(type: type)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imageUrls = try container.decode([String].self, forKey: .imageUrls)
        message = try container.decode(String.self, forKey: .message)
        tags = try container.decode([String].self, forKey: .tags)
        try super.init(from: decoder)
    }
    
}
