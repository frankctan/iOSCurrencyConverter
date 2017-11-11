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

        guard let eur = ratesJSON[Currency.EUR].double else {
            print("no EUR currency")
            throw CurrencyError.noData
        }

        guard let gbp = ratesJSON[Currency.GBP].double else {
            print("no GBP currency")
            throw CurrencyError.noData
        }

        guard let nzd = ratesJSON[Currency.NZD].double else {
            print("no NZD currency")
            throw CurrencyError.noData
        }

        var ratesDict = [String: Double]()
        ratesDict[Currency.EUR] = eur
        ratesDict[Currency.GBP] = gbp
        ratesDict[Currency.NZD] = nzd

        self.date = date
        self.rates = ratesDict
    }
}
