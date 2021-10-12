//
//  Double+Extension.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation

extension Double {
  var percentage: Percentage {
    return Percentage(percent: self)
  }
}
