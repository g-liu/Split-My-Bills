//
//  ReceiptModel.swift
//  Split My Bills
//
//  Created by Geoffrey Liu on 10/12/21.
//

import Foundation


/// Describes a receipt including taxes, tips, and adjustments
struct ReceiptModel {
  private var items: [ReceiptItemModel]
  
  private var adjustments: [AdjustmentModel]
  
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
}
