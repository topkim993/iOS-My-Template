//
//  DateExtension.swift
//  Template
//
//  Created by Topkim on 2022/01/18.
//

import Foundation

extension Date {
    func formatting(format: String, timeZone: TimeZone = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        return formatter.string(from: self)
    }
}
