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
  
  var whoIsPaying: [Bool] // this needs to be coupled MUCH closer to `BillModel`, at least the same count
  
  var isSomeonePaying: Bool { whoIsPaying.contains(true) }
  var numPayers: Int { whoIsPaying.sum }
}
