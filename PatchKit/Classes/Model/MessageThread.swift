//
//  MessageThread.swift
//  Pods
//
//  Created by Omar Rasheed on 5/24/20.
//

import Foundation

struct MessageThread: Codable {
    
    let messages: [Message]
    let hasAdminRead: Bool
    let hasUserRead: Bool
    
}
