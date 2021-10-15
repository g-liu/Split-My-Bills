//
//  Percentage.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation


/// Represents a portion of a whole
struct Percentage {
  
  /// The percentage represented as a double.
  /// Example: 15.1% would be represented as 15.1
  let percent: Double
  
  
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
    nf.maximumFractionDigits = places
    nf.locale = Locale.current
    return nf.string(from: NSNumber(value: percent / 100.0))!
  }
}

extension Percentage {
  static let zero = 0.0.percent
}

extension Percentage: Equatable, Hashable { }

extension Percentage: Comparable {
  static func < (lhs: Percentage, rhs: Percentage) -> Bool {
    lhs.percent < rhs.percent
  }
}
