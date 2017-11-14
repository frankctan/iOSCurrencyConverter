//
//  Extensions.swift
//  SailThruCurrencyConverter
//
//  Created by Frank Tan on 11/14/17.
//  Copyright © 2017 franktan. All rights reserved.
//

import Foundation

extension String {
    static func random(length: Int) -> String {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }

}
