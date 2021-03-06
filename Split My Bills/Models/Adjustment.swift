//
//  Adjustment.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation

/// Describes an adjustment to a bill, in terms of an amount or a percentage
enum Adjustment {
  /// Adjustment is given as a percent of the total bill
  case percentage(Percentage, ApplicablePortion)

  /// Adjustment is given as a fixed amount
  case amount(Amount)
  
  var formatted: String {
    switch self {
      case .amount(let amount):
        return amount.formatted
      case .percentage(let percentage, _):
        return percentage.formatted
    }
  }
}
extension Adjustment: Equatable, Hashable { }


/// Enum whose values describe what portion of the receipt an adjustment applies to
enum ApplicablePortion {

  /// Adjustment applies to subtotal only
  case subtotal
  
  /// Adjustment applies to running total
  case runningTotal
}
