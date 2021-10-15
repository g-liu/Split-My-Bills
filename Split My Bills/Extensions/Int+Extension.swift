//
//  Int+Extension.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation

extension Int {
  var percent: Percentage {
    Double(self).percent
  }
  
  var amount: Amount {
    Amount(rawValue: self)
  }
  
  static func +(left: Int, right: Bool) -> Int {
    left + right.asInt
  }
}
