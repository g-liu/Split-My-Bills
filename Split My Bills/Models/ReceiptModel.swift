//
//  ReceiptModel.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation


/// Describes a receipt including taxes, tips, and adjustments
struct ReceiptModel {
  var items: [ReceiptItemModel]
  
  var adjustments: [AdjustmentModel]
  
  init(items: [ReceiptItemModel] = [], adjustments: [AdjustmentModel] = []) {
    self.items = items
    self.adjustments = adjustments
  }
  
  mutating func addItem(_ item: ReceiptItemModel) {
    items.append(item)
  }
  
  @discardableResult
  mutating func removeItem(at index: Int) -> ReceiptItemModel? {
    guard index >= 0, index < items.count else { return nil }
    
    return items.remove(at: index)
  }
  
  mutating func addAdjustment(_ adjustment: AdjustmentModel) {
    adjustments.append(adjustment)
  }
  
  @discardableResult
  mutating func removeAdjustment(at index: Int) -> AdjustmentModel? {
    guard index >= 0, index < items.count else { return nil }
    
    return adjustments.remove(at: index)
  }
  
  /// The calculated total on the receipt
  var formattedTotal: String {
    let itemTotal = items.reduce(Amount.zero) { (result, model) -> Amount in
      result + model.itemCost
    }
    
    let grandTotal = adjustments.reduce(itemTotal) { (result, model) -> Amount in
      result + model.adjustment
    }
    
    return grandTotal.formatted
  }
  
  
  /// Calculates the amount owed by each person
  var splitBill: [PersonModel: Amount] {
    var owed: [PersonModel: Amount] = [:]
    
    
    items.forEach { item in
      item.payers.forEach { person in
        // TODO: NEED A FAIRER ALGORITHM TO DIVIDE REMAINDERS
        owed[person, default: 0.amount] += item.itemCost / item.payers.count
      }
    }
    
    // TODO: HERE WE NEED TO GET TOTAL # of payers
    // MERGE WITH BillStatemodel
//    adjustments.forEach { adjustment in
//      owed[person, default: 0.amount] += adjustment.adjustment /
//    }
    
    return owed
  }
}
