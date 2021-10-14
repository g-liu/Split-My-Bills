//
//  ReceiptItem.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/14/21.
//

import Foundation

struct ReceiptItem {
  var itemName: String
  var itemCost: Amount
  
  var isBillableToPayer: [Bool] // TODO: this needs to be coupled MUCH closer to `BillModel`, at least the same count
  
  var isSomeonePaying: Bool { isBillableToPayer.contains(true) }
  var numPayers: Int { isBillableToPayer.sum }
}
