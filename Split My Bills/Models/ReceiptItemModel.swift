//
//  ReceiptItemModel.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation

/// Describes a single item on the receipt
struct ReceiptItemModel {
  /// Description of the item
  var itemName: String
  
  /// Cost of item
  var itemCost: Amount
  
  /// People who are paying for the item
  var payers: [PersonModel]
  
  init(itemName: String, itemCost: Amount = .zero, payers: [PersonModel] = []) {
    self.itemName = itemName
    self.itemCost = itemCost
    self.payers = payers
  }
  
  var formattedItemCost: String {
    itemCost.formatted
  }
  
}

extension ReceiptItemModel: Equatable, Hashable { }
