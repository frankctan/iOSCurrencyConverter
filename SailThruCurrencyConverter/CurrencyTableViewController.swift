//
//  CurrencyTableViewController.swift
//  SailThruCurrencyConverter
//
//  Created by Frank Tan on 11/11/17.
//  Copyright © 2017 franktan. All rights reserved.
//

import UIKit

/// Base in USD.
class Currency {
    let name: String
    var value: Double

    init(name: String, value: Double) {
        self.name = name
        self.value = value
    }
}

class CurrencyTableViewController: UITableViewController {

    private var rates: [String: Double] = [Constants.USD : 1.0]
    private var convertFrom = Currency.init(name: Constants.USD, value: 1)
    private var convertTo = [Currency]()

    let formatter: NumberFormatter = {
        let _formatter = NumberFormatter()
        _formatter.numberStyle = .decimal
        _formatter.minimumFractionDigits = 2
        _formatter.maximumFractionDigits = 2
        _formatter.usesGroupingSeparator = true
        return _formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isEditing = true
        self.tableView.separatorStyle = .none

        Communicator.fetchRates { (rateOrNil, errorOrNil) in
            if let error = errorOrNil {
                print(error)
                return
            }

            guard let rate = rateOrNil else {
                print("this should never execute")
                return
            }

            self.convertTo = rate.rates.map({ (dict) -> Currency in
                return Currency(name: dict.key, value: dict.value)
            })

            for r in rate.rates {
                self.rates[r.key] = r.value
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.convertTo.count
        }

    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let currencyHeaderView = Bundle.main.loadNibNamed("CurrencyHeaderView",
                                                         owner: nil,
                                                         options: nil)?[0] as! CurrencyHeaderView

        currencyHeaderView.conversionLabel.text = section == 0 ? "CONVERT FROM " : "CONVERT TO "

        return currencyHeaderView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell",
                                                      for: indexPath) as! CurrencyTableViewCell

        let isConvertFrom = indexPath.section == 0
        let currency = isConvertFrom ? self.convertFrom : self.convertTo[indexPath.row]
        cell.inputTextField?.isHidden = !isConvertFrom
        cell.amountLabel?.isHidden = isConvertFrom

        cell.amountLabel?.text = formatter.string(from: NSNumber(value: currency.value))
        cell.currencyLabel?.text = currency.name

        let toolbar =
            UIToolbar(frame: CGRect(origin: .zero,
                                    size: CGSize(width: self.tableView.bounds.width, height: 50)))
        let doneItem = UIBarButtonItem(title: "convert",
                                       style: .done,
                                       target: self,
                                       action: #selector(doneButtonDidTap(_:)))
        let flex1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flex2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolbar.items = [flex1, doneItem, flex2]
        toolbar.sizeToFit()
        cell.inputTextField?.inputAccessoryView = toolbar

        return cell
    }

    @objc func doneButtonDidTap(_ sender: UIBarButtonItem) {
        let cell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! CurrencyTableViewCell
        let value = Double(cell.inputTextField?.text ?? "0.0") ?? 0.0
        self.setConvertFrom(value: value)
        cell.inputTextField.text = formatter.string(from: NSNumber(value: value))
        cell.inputTextField.resignFirstResponder()
        self.tableView.reloadData()
    }

    func setConvertFrom(value: Double) {
        self.convertFrom.value = value
        for currency in convertTo {
            let rate = (self.rates[currency.name] ?? 0.0) / (self.rates[self.convertFrom.name] ?? 1.0)
            currency.value = value * rate
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.tableView.bounds.height + self.tableView.bounds.origin.y - 100) / 4
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

        if to.section == 1 {
            let item = self.convertTo[fromIndexPath.row]
            self.convertTo.remove(at: fromIndexPath.row)
            self.convertTo.insert(item, at: to.row)
        } else {
            self.tableView.moveRow(at: IndexPath.init(row: 0, section: 0), to: IndexPath.init(row: 0, section: 1))

            let oldConvertFrom = self.convertFrom
            let item = self.convertTo[fromIndexPath.row]
            self.convertTo.remove(at: fromIndexPath.row)
            self.convertTo.insert(oldConvertFrom, at: to.row)
            self.convertFrom = item

            self.tableView.reloadData()
        }
    }


    override func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {

        return UITableViewCellEditingStyle.none
    }

    override func tableView(_ tableView: UITableView,
                            shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {

        return false
    }
}
