//
//  Date+Extensions.swift
//  SupportClient
//
//  Created by Yana Sang on 5/10/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import Foundation

extension Date {

    func convertToTimestamp() -> String {
        let formatter = DateFormatter()

        if Calendar.current.isDateInToday(self) {
            formatter.timeStyle = .short
            formatter.dateStyle = .none

            return formatter.string(from: self)
        } else if Calendar.current.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            formatter.timeStyle = .none
            formatter.dateStyle = .short

            return formatter.string(from: self)
        }
    }

}
