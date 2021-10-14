//
//  Array+Extension.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation

extension Array where Element == Amount {
  var sum: Amount {
    reduce(.zero) { $0 + $1 }
  }
}

extension Array where Element == Bool {
  var sum: Int {
    reduce(0) { $0 + $1 }
  }
}

extension Array where Element == Billee {
  var sum: Int {
    reduce(0) {
      switch $1.payingStatus {
        case .nonPaying: return $0
        case .paying(amountOwed: _): return $0 + 1
      }
    }
  }
}
