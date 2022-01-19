//
//  Log.swift
//  Template
//
//  Created by jeong on 2020/06/22.
//  Copyright © 2020 racos. All rights reserved.
//

import Foundation

class Log {
    static func d(_ msg: Any, file: String = #file, function: String = #function, line: Int = #line){
        #if DEBUG
        let fileName = file.split(separator: "/").last ?? ""
        let funcName = function.split(separator: "(").first ?? ""
        print("⚬ 🟢 [\(fileName)] \(funcName)(\(line)) : \(msg)")
        #endif
    }
    
    static func i(_ msg: Any, file: String = #file, function: String = #function, line: Int = #line){
        #if DEBUG
        let fileName = file.split(separator: "/").last ?? ""
        let funcName = function.split(separator: "(").first ?? ""
        print("⚬ 🔵 [\(fileName)] \(funcName)(\(line)) : \(msg)")
        #endif
    }
    
    static func e(_ msg: Any, file: String = #file, function: String = #function, line: Int = #line){
        let fileName = file.split(separator: "/").last ?? ""
        let funcName = function.split(separator: "(").first ?? ""
        print("⚬ 🔴 [\(fileName)] \(funcName)(\(line)) : \(msg)")
    }
}

