//
//  Bool+Extension.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/13/21.
//

import Foundation

extension Bool {
  var asInt: Int { self ? 1 : 0 }
  
  static func +(left: Bool, right: Bool) -> Int {
    left.asInt + right.asInt
  }
  
  static func +(left: Bool, right: Int) -> Int {
    left.asInt + right
  }
}
