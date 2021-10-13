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
