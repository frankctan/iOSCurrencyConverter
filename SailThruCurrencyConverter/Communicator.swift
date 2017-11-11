//
//  Communicator.swift
//  SailThruCurrencyConverter
//
//  Created by Frank Tan on 11/11/17.
//  Copyright © 2017 franktan. All rights reserved.
//

import Foundation
import SwiftyJSON

enum CurrencyError: Error {
    case noData
}

class Communicator {
    static let url = URL.init(string: "http://api.fixer.io/latest?base=USD")

    class func fetchRates(_ completion: ((CurrencyRate?, Error?) -> Void)?) {
        guard let url = self.url else {
            fatalError()
        }

        URLSession.shared.dataTask(with: url) { (dataOrNil, responseOrNil, errorOrNil) in
            if let error = errorOrNil {
                completion?(nil, error)
                return
            }

            guard let data = dataOrNil else {
                completion?(nil, CurrencyError.noData)
                return
            }

            let json = JSON(data: data)

            do {
                let rate = try CurrencyRate(json: json)
                completion?(rate, nil)
            } catch(let error) {
                completion?(nil, error)
            }
        }.resume()
    }
}

