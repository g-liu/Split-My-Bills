//
//  ItemsBreakdown.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/14/21.
//

import Foundation

struct ItemsBreakdown {
  var itemsBreakdown: [ItemBreakdown] = []
  var itemsSubtotal: Amount {
    itemsBreakdown.reduce(Amount.zero) { $0 + $1.costToPayer }
  }
}

struct ItemBreakdown {
  var item: ReceiptItem
  var costToPayer: Amount
}
