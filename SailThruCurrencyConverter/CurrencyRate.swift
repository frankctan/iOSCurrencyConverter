//
//  CurrencyRate.swift
//  SailThruCurrencyConverter
//
//  Created by Frank Tan on 11/11/17.
//  Copyright © 2017 franktan. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Assumes base in USD.
struct CurrencyRate {
    let date: String
    let rates: [String: Double]

    init(date: String, rates: [String: Double]) {
        self.date = date
        self.rates = rates
    }

    init(json: JSON) throws {
        guard let date = json["date"].string else {
            print("no date!")
            throw CurrencyError.noData
        }

        let ratesJSON = json["rates"]

        guard let eur = ratesJSON[Constants.EUR].double else {
            print("no EUR currency")
            throw CurrencyError.noData
        }

        guard let gbp = ratesJSON[Constants.GBP].double else {
            print("no GBP currency")
            throw CurrencyError.noData
        }

        guard let nzd = ratesJSON[Constants.NZD].double else {
            print("no NZD currency")
            throw CurrencyError.noData
        }

        var ratesDict = [String: Double]()
        ratesDict[Constants.EUR] = eur
        ratesDict[Constants.GBP] = gbp
        ratesDict[Constants.NZD] = nzd

        self.date = date
        self.rates = ratesDict
    }
}
