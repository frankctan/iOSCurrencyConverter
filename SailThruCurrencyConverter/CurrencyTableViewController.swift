//
//  CurrencyTableViewController.swift
//  SailThruCurrencyConverter
//
//  Created by Frank Tan on 11/11/17.
//  Copyright © 2017 franktan. All rights reserved.
//

import UIKit

// MARK: - Placeholder.
class CurrencyTableViewCell: UITableViewCell {}

/// Base in USD.
struct Currency {
    let name: String
    let value: Double

    init(name: String, value: Double) {
        self.name = name
        self.value = value
    }
}

class CurrencyTableViewController: UITableViewController {

    private var convertFrom = Currency.init(name: Constants.USD, value: 1)
    private var convertTo = [Currency]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: "cell")
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
        let header = UIView()
        header.backgroundColor = .blue
        return header
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell",
                                                      for: indexPath) as! CurrencyTableViewCell

        let currency = indexPath.section == 0 ? self.convertFrom : self.convertTo[indexPath.row]
        cell.detailTextLabel?.text = currency.name
        cell.textLabel?.text = String(currency.value)

        return cell
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
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
