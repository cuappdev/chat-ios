//
//  Date+Extensions.swift
//  SupportClient
//
//  Created by Yana Sang on 5/10/20.
//  Copyright © 2020 Cornell Appdev. All rights reserved.
//

import Foundation

extension Date {
    
    static func -(lhs: Date, rhs: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -rhs, to: lhs)!
    }

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
    
    /// Refer to https://nsdateformatter.com/ for formatting options under the "Reference" tab
    func formatDateString(format: String) -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = format
        return dateFormatterPrint.string(from: self)
    }
    
    func isBetween(date date1: Date, andDate date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }

}
