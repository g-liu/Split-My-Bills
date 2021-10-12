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
  case percentage(Percentage)

  /// Adjustment is given as a fixed amount
  case amount(Amount)
}
