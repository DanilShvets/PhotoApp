//
//  Printer.swift
//  PhotoApp
//
//  Created by Данил Швец on 04.04.2022.
//

import Foundation

final class Logger {
    static func log(_ items: Any..., separator: String = " ", terminator: String = "\n",
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {
        let func_ = function.prefix(while: { (char) in
            return char != "(" ? true : false
        })
        print("\(URL(string: file)?.lastPathComponent ?? "<unknown>"):\(line) (\(func_)): ", terminator: "")
        for item in items {
            print(item, separator: separator, terminator: "")
        }
        print("", terminator: terminator)
    }
}
