//
//  StringExtension.swift
//  Template
//
//  Created by Topkim on 2022/01/18.
//

import Foundation

extension String {
    func toDateByISO8601() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        return formatter.date(from: self)!
    }
}
