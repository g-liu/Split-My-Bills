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
  
  
  /// Portions the amount exactly into the number of pieces given, distributing the remainder as evenly as possible between the divided pieces
  /// - Parameter pieces: the number of portions to divide into. assumes a minimum of 1 piece
  func portion(into pieces: Int) -> [Amount] {
    guard pieces > 0 else {
      return []
    }
    
    let quotient = Int(floor(Double(rawValue) / Double(pieces)))
    let remainder = rawValue % pieces
    
    var divisions = Array(repeating: quotient.amount, count: pieces)
    
    if remainder > 0 {
      let lowStepSize = pieces / remainder
      let highStepSize = lowStepSize + 1
      let stepPattern = [highStepSize, lowStepSize]
      var lastDivisionIndex: Int = 0
      (0..<remainder).forEach {
        divisions[lastDivisionIndex] += 1.amount
        let stepSize = stepPattern[$0 % stepPattern.count]
        lastDivisionIndex += stepSize
        lastDivisionIndex %= pieces
      }
    }
    
    return divisions
  }
  
  static func +(left: Amount, right: Amount) -> Amount {
    return Amount(rawValue: left.rawValue + right.rawValue)
  }
  
  static func -(left: Amount, right: Amount) -> Amount {
    return Amount(rawValue: left.rawValue - right.rawValue)
  }
  
  func adjusted(by adjustment: Adjustment) -> Amount {
    switch adjustment {
      case .amount(let amount):
        return self + amount
      case .percentage(let percentage, _):
        return self + self * percentage
    }
  }
  
  static func *(left: Amount, right: Percentage) -> Amount {
    let rawPercentage = Double(right.percent / 100.0)
    return Amount(rawValue: Int(round(Double(left.rawValue) * rawPercentage)))
  }
  
  static func /(left: Amount, right: Int) -> Amount {
    let rawValue = Int(Double(left.rawValue) / Double(right))
    return Amount(rawValue: rawValue)
  }
  
  static func +=(left: inout Amount, right: Amount) {
    left = left + right
  }
  
  static func *=(left: inout Amount, right: Percentage) {
    left = left * right
  }
}


extension Amount {
  static let zero = Amount(rawValue: 0)
}


extension Amount: Equatable, Hashable { }
