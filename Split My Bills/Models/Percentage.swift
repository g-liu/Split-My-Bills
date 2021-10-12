//
//  Percentage.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation


/// Represents a portion of a whole
public struct Percentage {
  
  /// The percentage represented as a float.
  /// Example: 15.1% would be represented as 15.1
  let percent: Float
  
  
  /// Alias for getting the formatted percentage as a string
  var formatted: String {
    formatted()
  }
  
  /// Returns the Percentage expressed as a string
  /// - Parameter places: the number of decimal places to format to, defaulting to 1.
  /// - Returns: self expressed as a string
  func formatted(to places: Int = 1) -> String {
    let nf = NumberFormatter()
    nf.numberStyle = .percent
    // TODO: Decimal places??
    nf.locale = Locale.current
    return nf.string(from: NSNumber(value: percent))!
  }
}

extension Percentage {
  static let zero = Percentage(percent: 0.0)
}
