//
//  Amount.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation


/// Represents the cost of a single item
struct Amount {
  /// A raw representation of the amount, given as the number of cents (or equivalent base denomination)
  /// For example an item costing $10.99 would be represented by the value 1099
  var rawValue: Int
  
  var formatted: String {
    let nf = NumberFormatter()
    nf.numberStyle = .currency
    nf.maximumFractionDigits = 2
    return nf.string(from: NSNumber(value: Double(rawValue) / 100.0))!
  }
  
  static func +(left: Amount, right: Amount) -> Amount {
    return Amount(rawValue: left.rawValue + right.rawValue)
  }
  
  static func -(left: Amount, right: Amount) -> Amount {
    return Amount(rawValue: left.rawValue - right.rawValue)
  }
  
  static func +(left: Amount, right: Adjustment) -> Amount {
    switch right {
      case .amount(let amount):
        return left + amount
      case .percentage(let percentage):
        return left * percentage
    }
  }
  
  static func *(left: Amount, right: Percentage) -> Amount {
    let rawPercentage = Double(right.percent / 100 + 1.0)
    return Amount(rawValue: Int(round(Double(left.rawValue) * rawPercentage)))
  }
}


extension Amount {
  static let zero = Amount(rawValue: 0)
}


extension Amount: Equatable, Hashable { }
