//
//  BaseDomain.swift
//  Template
//
//  Created by Topkim on 2022/01/18.
//

import Foundation

class BaseDomain {
    func decodeError(_ data:Data) -> Error {
        return NSError(domain: "\(String(describing: String(data: data, encoding: .utf8)))", code: -1, userInfo: [NSLocalizedDescriptionKey : "Decoding error"])
    }
    
    func decodeError(data: Data, error: Error) -> Error {
        return NSError(
            domain: """
                
            Description
            \(error.localizedDescription)
            
            Error
            \(error)
            
            Fail data
            \(data.prettyPrintedJSONString ?? "")
            """,
            code: -1,
            userInfo: [NSLocalizedDescriptionKey : "Decoding error"]
        )
    }
}
