//
//  TwoWayFeedback.swift
//  SupportClient
//
//  Created by Omar Rasheed on 5/20/20.
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

    override init(imageUrls: [String], message: String, tags: [String], type: FeedbackType) {
        self.hasRead = true
        self.adminRep = nil
        super.init(imageUrls: imageUrls, message: message, tags: tags, type: type)
    }


    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hasRead = try container.decode(Bool.self, forKey: .hasRead)
        adminRep = try? container.decode(AdminRep.self, forKey: .adminRep)
        try super.init(from: decoder)
    }

}
