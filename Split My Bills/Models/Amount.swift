//
//  Amount.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation


/// Represents the cost of a single item
struct Amount {
  /// A raw representation of the item, given as a Double
  /// For example an item costing $10.99 would be represented by the value 10.99
  var rawValue: Double
  
  var formatted: String {
    let nf = NumberFormatter()
    nf.numberStyle = .currency
    return nf.string(from: NSNumber(value: rawValue))!
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
    return Amount(rawValue: left.rawValue * rawPercentage)
  }
}


extension Amount {
  static let zero = Amount(rawValue: 0)
}


extension Amount: Equatable, Hashable { }
