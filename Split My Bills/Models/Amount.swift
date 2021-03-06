//
//  Amount.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation


/// Represents the cost of a single item
struct Amount {
  typealias PortionWithRemainder = (portion: Amount, remainder: Amount)
  /// A raw representation of the amount, given as the number of cents (or equivalent base denomination)
  /// For example an item costing $10.99 would be represented by the value 1099
  var rawValue: Int
  
  var formatted: String {
    let nf = NumberFormatter()
    nf.numberStyle = .currency
    nf.maximumFractionDigits = 2
    return nf.string(from: NSNumber(value: Double(rawValue) / 100.0))!
  }
  
  
  /// Returns the quotient and remainder Amounts resulting from portioning an Amount into a given number of pieces
  /// - Parameter pieces: the number of portions to divide into. assumes a minimum of 1 piece
  func portion(into pieces: Int) -> PortionWithRemainder {
    guard pieces > 0 else {
      return (.zero, .zero)
    }
    
    let quotient = floor(Double(rawValue) / Double(pieces)).amount
    let remainder = (rawValue % pieces).amount
    
    return (quotient, remainder)
  }
  
  static func +(left: Amount, right: Amount) -> Amount {
    .init(rawValue: left.rawValue + right.rawValue)
  }
  
  static func -(left: Amount, right: Amount) -> Amount {
    .init(rawValue: left.rawValue - right.rawValue)
  }
  
  static func *(left: Amount, right: Percentage) -> Amount {
    let rawPercentage = right.percent / 100.0
    return .init(rawValue: Int(round(Double(left.rawValue) * rawPercentage)))
  }
  
  static func *(left: Amount, right: Int) -> Amount {
    .init(rawValue: left.rawValue * right)
  }
  
  static func %(left: Amount, right: Percentage) -> Double {
    let rawPercentage = right.percent / 100.0
    let rawAmount = Double(left.rawValue) * rawPercentage
    return rawAmount - floor(rawAmount)
  }
  
  static func /(left: Amount, right: Int) -> Amount {
    let rawValue = Double(left.rawValue) / Double(right)
    guard !rawValue.isNaN else { return .zero }
    return .init(rawValue: Int(round(rawValue)))
  }
  
  static func /(left: Amount, right: Amount) -> Percentage {
    let rawValue = Double(left.rawValue) / Double(right.rawValue)
    return Percentage(percent: rawValue)
  }
  
  // TODO: Deprecate (see above)
  static func +=(left: inout Amount, right: Amount) {
    left = left + right
  }

  // TODO: Deprecate (see above)
  static func *=(left: inout Amount, right: Percentage) {
    left = left * right
  }
}


extension Amount {
  static let zero = Amount(rawValue: 0)
}


extension Amount: Equatable, Hashable { }

extension Amount: Comparable {
  static func < (lhs: Amount, rhs: Amount) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}
