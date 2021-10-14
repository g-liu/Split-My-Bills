//
//  ItemsBreakdown.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/14/21.
//

import Foundation

struct ItemsBreakdown {
  var itemsBreakdown: [ItemBreakdown] = []
  
  var subtotalToPayer: Amount {
    itemsBreakdown.reduce(Amount.zero) { $0 + $1.costToPayer }
  }
  
  var itemsSubtotal: Amount {
    itemsBreakdown.reduce(Amount.zero) { $0 + $1.item.itemCost }
  }
  
  var percentageOfSubtotal: Percentage {
    subtotalToPayer * 100 / itemsSubtotal
  }
}

struct ItemBreakdown {
  var item: ReceiptItem
  var costToPayer: Amount
}
