//
//  AdjustmentsBreakdown.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/14/21.
//

import Foundation

struct AdjustmentsBreakdown {
  var adjustmentsBreakdown: [AdjustmentBreakdown] = []
  var percentageOfSubtotal: Percentage = .zero
  
  var adjustmentsTotal: Amount {
    adjustmentsBreakdown.reduce(Amount.zero) { $0 + $1.costEquivalentToPayer }
  }
}

struct AdjustmentBreakdown {
  var adjustment: ReceiptAdjustment
  var costEquivalentToPayer: Amount
}
