//
//  BaseApi.swift
//  Template
//
//  Created by Topkim on 2022/01/18.
//

import Foundation

import Foundation
import UIKit

class BaseApi {
    
    private static let BASE_URL = "https://api.giphy.com/v1"
    
    static func getBaseURL() -> String {
        return BASE_URL
    }
}
