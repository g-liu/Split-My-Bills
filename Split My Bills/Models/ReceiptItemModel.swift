//
//  ReceiptItemModel.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation

struct ReceiptItemModel {
  
  /// Description of the item
  var itemName: String
  
  /// Cost of item
  var itemCost: Double
  
  var formattedItemCost: String {
    let nf = NumberFormatter()
    nf.numberStyle = .currency
    return nf.string(from: NSNumber(value: itemCost))!
  }
}
