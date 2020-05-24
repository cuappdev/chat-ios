//
//  TwoWayFeedback.swift
//  SupportClient
//
//  Created by Omar Rasheed on 5/20/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import Foundation

class TwoWayFeedback: Feedback {

    let adminRep: AdminRep?
    let hasRead: Bool
    let messageThread: MessageThread

    enum CodingKeys: String, CodingKey {
        case adminRep
        case hasRead
        case messageThread
    }

    init(imageUrls: [String], message: String, tags: [String], type: FeedbackType) {
        self.hasRead = true
        self.adminRep = nil
        self.messageThread = MessageThread(messages: [Message(content: message, imageUrls: imageUrls, isFromAdmin: false)])
        super.init(type: type)
    }


    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hasRead = try container.decode(Bool.self, forKey: .hasRead)
        adminRep = try? container.decode(AdminRep.self, forKey: .adminRep)
        messageThread = try container.decode(MessageThread.self, forKey: .messageThread)
        try super.init(from: decoder)
    }

}
