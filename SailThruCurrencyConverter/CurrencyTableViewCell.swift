//
//  CurrencyTableViewCell.swift
//  SailThruCurrencyConverter
//
//  Created by Frank Tan on 11/12/17.
//  Copyright © 2017 franktan. All rights reserved.
//

import Foundation
import UIKit

class CurrencyTableViewCell: UITableViewCell {
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var wrapView: UIView! {
        didSet {
            self.wrapView.layer.cornerRadius = 10.0
        }
    }
}
